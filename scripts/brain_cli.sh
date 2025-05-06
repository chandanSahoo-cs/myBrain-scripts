#!/bin/bash

VENV_PATH="/home/chandan/myBrain/venv" # Update if your virtual environment is elsewhere
ACTIVATE_SCRIPT="$VENV_PATH/bin/activate"

while true; do
    echo "Entering the realm"
    source "$ACTIVATE_SCRIPT"

    echo "⚙️ Syncing notes..."
    python /home/chandan/myBrain/scripts/create_embeddings.py

    echo "Ask your questions (type 'exit' to leave LLM mode):"
    while true; do
        read -p "💬 You: " QUESTION
        if [[ "$QUESTION" == "exit" ]]; then
            echo "👋 Exiting the realm"
            break
        fi
        python /home/chandan/myBrain/scripts/langchain_integration.py "$QUESTION"
    done

    deactivate
    if [[ true ]]; then
        break
    fi

done
