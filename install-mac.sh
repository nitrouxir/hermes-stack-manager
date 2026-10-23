#!/usr/bin/env bash
# ==============================================================================
#  Hermes AI Stack - Automated Full Installer for macOS
#  Ecosystem: Nitroux (https://nitroux.ir)
# ==============================================================================

set -e

echo "======================================================================"
echo "    Hermes Stack - Automated Installer for macOS (by Nitroux)"
echo "    Website: https://nitroux.ir"
echo "======================================================================"

# 1. Check / Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "[->] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[OK] Homebrew is already installed."
fi

# 2. Check Prerequisites (git, node, python3, python-tk)
echo "[->] Checking prerequisites (Git, Node.js, Python, Python-Tk)..."
brew install git node python python-tk uv 2>/dev/null || true

# 3. Install 9Router
echo "[->] Installing 9Router via npm..."
npm install -g 9router@latest

# 4. Install Hermes Agent CLI
echo "[->] Checking Hermes Agent..."
if ! command -v hermes &> /dev/null && [ ! -f "$HOME/.local/bin/hermes" ]; then
    echo "[->] Downloading Hermes Agent..."
    curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash || true
fi

# 5. Clone & Setup Hermes WebUI
echo "[->] Setting up Hermes WebUI..."
WEBUI_DIR="$HOME/hermes-webui"
if [ ! -d "$WEBUI_DIR" ]; then
    git clone https://github.com/nesquena/hermes-webui.git "$WEBUI_DIR"
fi

cd "$WEBUI_DIR"
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# 6. Configure 9Router Endpoint
mkdir -p "$HOME/.hermes"
CONFIG_FILE="$HOME/.hermes/config.yaml"
if [ ! -f "$CONFIG_FILE" ]; then
    cat <<EOF > "$CONFIG_FILE"
model:
  default: ag/gemini-3.8-flash
  provider: openai-api
  base_url: http://127.0.0.1:20128/v1
  api_key: sk-nitroux-local
agent:
  max_turns: 90
terminal:
  backend: local
  timeout: 180
EOF
fi

# 7. Setup .hermes-stack directory in user home
STACK_DIR="$HOME/.hermes-stack"
mkdir -p "$STACK_DIR"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/HermesManager.py" "$STACK_DIR/" 2>/dev/null || true

echo ""
echo "======================================================================"
echo "  [OK] Hermes Stack installation complete!"
echo "  To launch the Control Center:"
echo "    python3 HermesManager.py"
echo "======================================================================"
