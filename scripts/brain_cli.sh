#!/bin/bash

VENV_PATH="/home/chandan/myBrain/venv" # Update this path if needed
ACTIVATE_SCRIPT="$VENV_PATH/bin/activate"

# ASCII Banner
clear
cat <<"EOF"
╔══════════════════════════════════════╗
║         ENTERING THE REALM           ║
║       A Gateway to Your Mind         ║
╚══════════════════════════════════════╝
EOF

# Start main loop
while true; do
    echo ""
    echo "⟡ Initializing Mental Framework..."
    source "$ACTIVATE_SCRIPT"

    echo ""
    echo "⟡ [⚙] Syncing with Thought Repository..."
    python /home/chandan/myBrain/scripts/create_embeddings.py
    echo ""

    echo "⟡ The Realm awaits your inquiry."
    echo "⟡ Type 'exit' to close the gateway."
    echo ""

    while true; do
        read -p "↳ You: " QUESTION
        if [[ "$QUESTION" == "exit" ]]; then
            echo ""
            echo "⟡ Closing the Realm..."
            break
        fi
        echo ""
        echo "⟡ Sending your thoughts into the Ether..."
        python /home/chandan/myBrain/scripts/langchain_integration.py "$QUESTION"
        echo ""
    done

    deactivate
    echo ""
    echo "⟡ Mental Portal Sealed."
    break
done

# Goodbye Message
echo ""
cat <<"EOF"
╔═════════════════════════════════════════════╗
║     THE REALM HAS CLOSED FOR NOW.           ║
║     Return anytime to seek deeper insight.  ║
╚═════════════════════════════════════════════╝

EOF
