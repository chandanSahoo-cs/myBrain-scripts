#!/bin/bash

VENV_PATH="/home/chandan/myBrain/venv"
ACTIVATE_SCRIPT="$VENV_PATH/bin/activate"

# ──────────────── CLI Output Helpers ────────────────

divider() {
    echo ""
    echo "────────────────────────────────────────────────────────────"
    echo ""
}

print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                  R E A L M   C L I                       ║"
    echo "║        Interactive Interface for Mind Expansion          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
}

section_activation() {
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  ≫ Construct Activation                                 ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo ""
}

section_sync() {
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  ⇄ Knowledge Synchronization                            ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo ""
}

section_console() {
    echo ""
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃  ∷ Realm Console                                        ┃"
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
    echo ""
}

footer() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║               ⊘  R E A L M   C L O S E D                 ║"
    echo "║    Re-enter when you're ready to explore deeper truth.   ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo ""
}

# ──────────────── Logging Helpers ────────────────

log_info() {
    printf "┃ [INFO]   %s\n" "$1"
}

log_step() {
    printf "┃ [STEP]   %s\n" "$1"
}

log_done() {
    printf "┃ [DONE]   %s\n" "$1"
}

log_warn() {
    printf "┃ [WARN]   %s\n" "$1"
}

log_exit() {
    printf "┃ [EXIT]   %s\n" "$1"
}

log_input() {
    printf "┃ [ASK]    > "
}

# ──────────────── REALM CLI START ────────────────

clear
print_header

while true; do
    section_activation
    log_info "Initializing virtual environment..."
    source "$ACTIVATE_SCRIPT"
    log_done "Environment activated."
    divider

    section_sync
    log_step "Running embedding generator..."
    python /home/chandan/myBrain/scripts/create_embeddings.py
    log_done "Embeddings successfully updated."
    divider

    section_console
    log_info "The Construct is ready to receive input."
    log_info "Type 'exit' or '⊘' to end the session."
    divider

    while true; do
        log_input
        read QUESTION
        if [[ "$QUESTION" == "exit" || "$QUESTION" == "⊘" ]]; then
            log_exit "Exiting the Realm console..."
            break
        fi
        log_step "Sending your thoughts to the Construct..."
        python /home/chandan/myBrain/scripts/langchain_integration.py "$QUESTION"
        log_done "Response delivered."
        divider
    done

    log_info "Deactivating the Construct..."
    deactivate
    log_done "Environment closed."
    divider
    break
done

footer
