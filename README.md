# REALM: Obsidian Vault + LLM Query System

REALM is a personal knowledge management system that connects your Obsidian vault to a local vector store and lets you query your notes using a Large Language Model (LLM). It supports automatic syncing, embedding with Chroma DB, and querying with Gemini via LangChain.

---

## 🚀 Features

* Syncs only updated or new Markdown files from your Obsidian vault
* Stores embeddings locally using ChromaDB
* Queries your notes using Gemini (Google Generative AI)
* Command-line interface for seamless access

---

## 📁 Project Structure

```
myBrain/
│
├── embeddings/              # Stores Chroma vector database and metadata
├── scripts/
│   ├── create_embeddings.py # Sync and embed vault notes
│   └── langchain_integration.py # LLM querying logic
├── .env                     # Stores environment variables (DO NOT COMMIT)
├── brain.sh                 # CLI entrypoint script
├── requirements.txt         # Python dependencies
└── README.md
```

---

## ⚙️ Setup

### 1. Clone the Repo

```bash
git clone https://github.com/yourusername/myBrain.git
cd myBrain
```

### 2. Create a Python Virtual Environment

```bash
python -m venv .venv
source .venv/bin/activate
```

### 3. Install Requirements

```bash
pip install -r requirements.txt
```

### 4. Create a `.env` File

```env
VAULT_PATH=/absolute/path/to/your/obsidian/vault
GEMINI_API_KEY=your_google_gemini_api_key
```

## Run the script
Now you can run the script anytime 
```bash
./brain.sh
```

This will:

1. Activate the virtual environment
2. Sync and embed updated notes from your vault
3. Start the LLM-powered QA system
4. Prompt you to ask questions about your knowledge base
5. Type `exit` to quit

