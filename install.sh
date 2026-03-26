#!/usr/bin/env bash
# Install dictfix CLI and its dependency (espanso)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/bin/dictfix"

# ─── Helper ───────────────────────────────────────
prompt_yn() {
  local message="$1" default="${2:-y}"
  local yn
  if [[ "$default" == "y" ]]; then
    read -rp "$message [Y/n] " yn
    yn="${yn:-y}"
  else
    read -rp "$message [y/N] " yn
    yn="${yn:-n}"
  fi
  [[ "$yn" =~ ^[Yy] ]]
}

echo "────────────────────────────────────────"
echo "  dictfix installer"
echo "────────────────────────────────────────"
echo ""

# ─── Step 1: Dependencies ─────────────────────────
echo "Step 1: Dependencies"
echo ""

# Check for Homebrew
if ! command -v brew &>/dev/null; then
  echo "  Homebrew is required but not installed."
  echo "  Install from: https://brew.sh"
  exit 1
fi
echo "  [OK] Homebrew found"

# Check for Python 3
if ! command -v python3 &>/dev/null; then
  echo "  [!!] Python 3 is required but not found."
  exit 1
fi
echo "  [OK] Python 3 found"

# Check for espanso
if brew list --cask espanso &>/dev/null; then
  echo "  [OK] espanso is already installed"
else
  echo ""
  if prompt_yn "  Install espanso (required dependency)?"; then
    echo "  Installing espanso..."
    brew install espanso
    echo ""
    echo "  IMPORTANT: Grant macOS permissions for espanso:"
    echo "    1. System Settings > Privacy & Security > Accessibility  -> enable Espanso"
    echo "    2. System Settings > Privacy & Security > Input Monitoring -> enable Espanso"
    echo ""
  else
    echo "  Skipped. dictfix requires espanso to function."
    echo "  Install later with: brew install espanso"
    echo ""
  fi
fi

# ─── Step 2: Install dictfix ──────────────────────
echo ""
echo "Step 2: Install dictfix CLI"
echo ""

# Ensure ~/bin exists
mkdir -p "$HOME/bin"

# Symlink the script
ln -sf "$SCRIPT_DIR/dictfix" "$TARGET"
chmod +x "$SCRIPT_DIR/dictfix"
echo "  [OK] Installed: $TARGET -> $SCRIPT_DIR/dictfix"

# Check if ~/bin is in PATH
if [[ ":$PATH:" != *":$HOME/bin:"* ]]; then
  echo ""
  echo "  [!!] ~/bin is not in your PATH. Add this to your shell profile:"
  echo "       export PATH=\"\$HOME/bin:\$PATH\""
fi

# ─── Step 3: Register espanso as a service ────────
echo ""
echo "Step 3: Service registration"
echo ""
echo "  espanso runs as a background service to apply corrections in real time."
echo "  Registering it ensures it auto-starts after reboot."
echo ""

if command -v espanso &>/dev/null; then
  # Check if already registered
  if [[ -f "$HOME/Library/LaunchAgents/com.federicoterzi.espanso.plist" ]]; then
    echo "  [OK] espanso is already registered as a login service"

    # Try to start if not running
    if espanso status &>/dev/null 2>&1; then
      echo "  [OK] espanso is running"
    else
      if prompt_yn "  espanso is not running. Start it now?"; then
        espanso start 2>/dev/null || espanso restart 2>/dev/null || true
        echo "  Started (if permissions are granted)."
      fi
    fi
  else
    if prompt_yn "  Register espanso as a login service (auto-start on reboot)?"; then
      espanso service register 2>/dev/null && echo "  [OK] Service registered" || echo "  [!!] Registration failed — try: espanso service register"

      if prompt_yn "  Start espanso now?"; then
        espanso start 2>/dev/null || true
        echo "  Started (if permissions are granted)."
      fi
    else
      echo "  Skipped. Register later with: espanso service register"
    fi
  fi
else
  echo "  [..] espanso not installed — skipping service registration"
fi

# ─── Step 4: Create espanso config if missing ─────
ESPANSO_CONFIG="$HOME/.config/espanso/config/default.yml"
ESPANSO_MATCH_DIR="$HOME/.config/espanso/match"

if [[ ! -d "$HOME/.config/espanso" ]]; then
  mkdir -p "$HOME/.config/espanso/config" "$ESPANSO_MATCH_DIR"
  cat > "$ESPANSO_CONFIG" <<'YAML'
# Espanso default configuration
# https://espanso.org/docs/configuration/
key_delay: 10
search_shortcut: ALT+SPACE
YAML
  echo ""
  echo "  [OK] Created espanso config directory"
fi

# ─── Step 5: Shell alias ──────────────────────────
echo ""
echo "Step 5: Shell alias"
echo ""
echo "  The 'dfx' alias provides a shorthand for 'dictfix'."
echo ""

# Detect shell profile
SHELL_PROFILE=""
if [[ -f "$HOME/.zshrc" ]]; then
  SHELL_PROFILE="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
  SHELL_PROFILE="$HOME/.bashrc"
elif [[ -f "$HOME/.bash_profile" ]]; then
  SHELL_PROFILE="$HOME/.bash_profile"
fi

if [[ -n "$SHELL_PROFILE" ]]; then
  if grep -q "alias dfx=" "$SHELL_PROFILE" 2>/dev/null; then
    echo "  [OK] dfx alias already exists in $(basename "$SHELL_PROFILE")"
  else
    if prompt_yn "  Add 'dfx' alias to $(basename "$SHELL_PROFILE")?"; then
      echo "" >> "$SHELL_PROFILE"
      echo "# ================================" >> "$SHELL_PROFILE"
      echo "# Dictation Fix (dictfix / dfx)" >> "$SHELL_PROFILE"
      echo "# ================================" >> "$SHELL_PROFILE"
      echo "alias dfx='dictfix'            # shorthand for dictfix CLI (speech-to-text corrections)" >> "$SHELL_PROFILE"
      # shellcheck disable=SC1090
      source "$SHELL_PROFILE" 2>/dev/null || true
      echo "  [OK] dfx alias added to $(basename "$SHELL_PROFILE")"
    else
      echo "  Skipped. Add manually later:"
      echo "    echo \"alias dfx='dictfix'\" >> $(basename "$SHELL_PROFILE")"
    fi
  fi
else
  echo "  [!!] Could not detect shell profile (.zshrc, .bashrc, .bash_profile)"
  echo "       Add manually: alias dfx='dictfix'"
fi

# ─── Done ─────────────────────────────────────────
echo ""
echo "────────────────────────────────────────"
echo "  Installation complete!"
echo ""
echo "  Next steps:"
echo "    1. Open a new terminal (or run: source ~/.zshrc)"
echo "    2. Run: dictfix doctor    (verify your setup)"
echo "    3. Run: dictfix add \"wrong\" \"correct\""
echo "────────────────────────────────────────"
