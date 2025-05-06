import os
import sys
import warnings

from dotenv import load_dotenv
from langchain.chains import VectorDBQA
from langchain_chroma import Chroma
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_huggingface import HuggingFaceEmbeddings

# Suppress warnings
warnings.filterwarnings("ignore")

load_dotenv()
gemini_api_key = os.getenv("GEMINI_API_KEY")

# Load vectorstore and embedding
embedding_model = HuggingFaceEmbeddings(
    model_name="sentence-transformers/all-MiniLM-L6-v2"
)
vectorstore = Chroma(
    persist_directory="./embeddings", embedding_function=embedding_model
)

# Setup LLM
llm = ChatGoogleGenerativeAI(
    api_key=gemini_api_key, model="gemini-2.0-flash", temperature=0.5
)

# Setup QA chain
qa_chain = VectorDBQA.from_chain_type(llm=llm, vectorstore=vectorstore)

# Get query
query = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else input("Enter your query: ")

# Run
results = qa_chain.invoke(query)
print("⟁ Answer:", results.get("result"))
