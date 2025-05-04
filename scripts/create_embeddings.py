import glob
import os

import chromadb
from sentence_transformers import SentenceTransformer

# Get path from environment or default
VAULT_PATH = os.environ.get("VAULT_PATH", "./vault")

# Initialize Chroma DB
client = chromadb.PersistentClient(path="./embeddings")
collection = client.get_or_create_collection(name="my_brain_notes")

# Load the embedding model
model = SentenceTransformer("all-MiniLM-L6-v2")

# Collect all markdown files
md_files = glob.glob(os.path.join(VAULT_PATH, "**", "*.md"), recursive=True)


def read_markdown(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return f.read()


documents, ids = [], []

for file_path in md_files:
    content = read_markdown(file_path)
    if not content.strip():
        continue

    doc_id = os.path.relpath(file_path, VAULT_PATH)
    documents.append(content)
    ids.append(doc_id)

if not documents:
    raise ValueError("❌ No markdown files found or embedded!")

embeddings = model.encode(documents, show_progress_bar=True)
collection.upsert(
    documents=documents,
    embeddings=[e.tolist() for e in embeddings],
    ids=ids,
)

print(f"✅ Embedded and stored {len(documents)} notes into Chroma.")
print(f"🧠 Document IDs embedded: {ids}")
