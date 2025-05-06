import hashlib
import json
import os

from dotenv import load_dotenv
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_chroma import Chroma
from langchain_community.document_loaders import DirectoryLoader
from langchain_core.documents import Document
from langchain_huggingface import HuggingFaceEmbeddings

load_dotenv()
VAULT_PATH = os.environ.get("VAULT_PATH")
PERSIST_DIR = "embeddings"
METADATA_FILE = os.path.join(PERSIST_DIR, "metadata.json")


def compute_hash(content):
    return hashlib.sha256(content.encode("utf-8")).hexdigest()


def load_metadata():
    if os.path.exists(METADATA_FILE):
        with open(METADATA_FILE, "r") as f:
            return json.load(f)
    return {}


def save_metadata(metadata):
    os.makedirs(PERSIST_DIR, exist_ok=True)
    with open(METADATA_FILE, "w") as f:
        json.dump(metadata, f, indent=2)


def load_documents():
    loader = DirectoryLoader(VAULT_PATH, glob="**/*.md", show_progress=True)
    return loader.load()


def split_documents(documents):
    splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=100)
    return splitter.split_documents(documents)


def sync_and_embed():
    embedding_model = HuggingFaceEmbeddings(model_name="all-MiniLM-L6-v2")
    db = Chroma(
        embedding_function=embedding_model,
        persist_directory=PERSIST_DIR,
    )

    old_meta = load_metadata()
    new_meta = {}
    all_docs = load_documents()

    all_chunks = []
    ids_to_add = []
    ids_to_remove = []

    seen_files = set()

    for doc in all_docs:
        file_path = doc.metadata["source"]
        seen_files.add(file_path)

        content_hash = compute_hash(doc.page_content)
        previous = old_meta.get(file_path)
        new_meta[file_path] = {
            "hash": content_hash,
            "chunks": 0,
        }  # will update chunk count after splitting

        if previous is None or previous["hash"] != content_hash:
            # Delete old chunks if any
            if previous:
                for i in range(previous["chunks"]):
                    ids_to_remove.append(f"{file_path}::chunk_{i}")

            # Add new chunks
            chunks = split_documents([doc])
            new_meta[file_path]["chunks"] = len(chunks)

            for i, chunk in enumerate(chunks):
                chunk_id = f"{file_path}::chunk_{i}"
                chunk.metadata["source"] = file_path
                all_chunks.append(
                    Document(page_content=chunk.page_content, metadata=chunk.metadata)
                )
                ids_to_add.append(chunk_id)
        else:
            # No changes
            new_meta[file_path] = previous

    # Handle deleted files
    for file_path, meta in old_meta.items():
        if file_path not in seen_files:
            for i in range(meta["chunks"]):
                ids_to_remove.append(f"{file_path}::chunk_{i}")

    if ids_to_remove:
        db.delete(ids=ids_to_remove)
        print(f"🗑️ Removed {len(ids_to_remove)} outdated chunks.")

    if all_chunks:
        db.add_documents(documents=all_chunks, ids=ids_to_add)
        print(f"✓ Added/updated {len(all_chunks)} chunks.")

    save_metadata(new_meta)
    print("↻ Sync complete.")


if __name__ == "__main__":
    sync_and_embed()
