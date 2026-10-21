#!/usr/bin/env bash
# Copyright 2026 The Gino's Super Dev Env Authors
# SPDX-License-Identifier: Apache-2.0
# =============================================================================
# install.sh — Gino's Super Dev Env Interactive Installer
# =============================================================================
# Usage:
#   ./install.sh              # Interactive wizard (asks questions with smart defaults)
#   ./install.sh --defaults   # Non-interactive install using detected/default settings
#   ./install.sh --dry-run    # Preview all changes without modifying any files
#   ./install.sh --uninstall  # Restore dotfiles from the latest ~/.dev-env-backup
# =============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="$HOME/.dev-env-backup"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="${BACKUP_ROOT}/${TIMESTAMP}"

DRY_RUN=false
USE_DEFAULTS=false
UNINSTALL=false

# Colors for terminal output
BOLD="\033[1m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

info()  { printf "${CYAN}[INFO]${RESET} %s\n" "$*"; }
ok()    { printf "${GREEN}[ OK ]${RESET} %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${RESET} %s\n" "$*"; }
err()   { printf "${RED}[ERR ]${RESET} %s\n" "$*" >&2; }

usage() {
    sed -n '4,12p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -y|--defaults|--yes)
            USE_DEFAULTS=true
            shift
            ;;
        -u|--uninstall|--restore)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            err "Unknown option: $1"
            usage
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Uninstall / Restore Mode
# -----------------------------------------------------------------------------
if [[ "$UNINSTALL" == "true" ]]; then
    if [[ ! -d "$BACKUP_ROOT" ]]; then
        err "No backup directory found at $BACKUP_ROOT"
        exit 1
    fi
    LATEST_BACKUP="$(ls -1dt "${BACKUP_ROOT}"/* 2>/dev/null | head -n 1 || true)"
    if [[ -z "$LATEST_BACKUP" ]]; then
        err "No backups found inside $BACKUP_ROOT"
        exit 1
    fi
    info "Restoring dotfiles from latest backup: $LATEST_BACKUP"
    if [[ "$DRY_RUN" == "true" ]]; then
        find "$LATEST_BACKUP" -type f
        exit 0
    fi
    cp -Rv "$LATEST_BACKUP/." "$HOME/"
    ok "Restore complete from $LATEST_BACKUP"
    exit 0
fi

# -----------------------------------------------------------------------------
# Helper: Prompt user with a default value
# -----------------------------------------------------------------------------
prompt_val() {
    local prompt_text="$1"
    local default_val="$2"
    local result=""
    if [[ "$USE_DEFAULTS" == "true" ]]; then
        printf "%s" "$default_val"
        return
    fi
    read -r -p "$(printf "${BOLD}%s${RESET} [${CYAN}%s${RESET}]: " "$prompt_text" "$default_val")" result </dev/tty || true
    if [[ -z "$result" ]]; then
        printf "%s" "$default_val"
    else
        printf "%s" "$result"
    fi
}

prompt_yes_no() {
    local prompt_text="$1"
    local default_ans="${2:-y}"
    if [[ "$USE_DEFAULTS" == "true" ]]; then
        [[ "$default_ans" =~ ^[Yy] ]] && return 0 || return 1
    fi
    local hint="Y/n"
    [[ "$default_ans" =~ ^[Nn] ]] && hint="y/N"
    local ans=""
    read -r -p "$(printf "${BOLD}%s${RESET} (%s): " "$prompt_text" "$hint")" ans </dev/tty || true
    ans="${ans:-$default_ans}"
    [[ "$ans" =~ ^[Yy] ]]
}

# -----------------------------------------------------------------------------
# 1. Detect Existing Environment Defaults (so nothing is lost)
# -----------------------------------------------------------------------------
EXISTING_AGY_SETTINGS="$HOME/.gemini/antigravity-cli/settings.json"
DEFAULT_GCP_PROJECT="your-gcp-project-id"
DEFAULT_GCP_LOCATION="global"
DEFAULT_WORKSPACE_DIR="$HOME/Repositories"
DEFAULT_MULTIPLEXER="tmux"

if [[ -f "$EXISTING_AGY_SETTINGS" ]] && command -v python3 >/dev/null 2>&1; then
    DETECTED_PROJ="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("gcp",{}).get("project",""))' "$EXISTING_AGY_SETTINGS" 2>/dev/null || true)"
    DETECTED_LOC="$(python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); print(d.get("gcp",{}).get("location",""))' "$EXISTING_AGY_SETTINGS" 2>/dev/null || true)"
    [[ -n "$DETECTED_PROJ" ]] && DEFAULT_GCP_PROJECT="$DETECTED_PROJ"
    [[ -n "$DETECTED_LOC" ]]  && DEFAULT_GCP_LOCATION="$DETECTED_LOC"
fi

# Detect existing HOMEBREW_GITHUB_API_TOKEN in ~/.secrets or ~/.bash_profile
DETECTED_GH_TOKEN=""
for f in "$HOME/.secrets" "$HOME/.bash_profile"; do
    if [[ -f "$f" ]]; then
        tok="$(grep -E '^[[:space:]]*(export[[:space:]]+)?HOMEBREW_GITHUB_API_TOKEN=' "$f" 2>/dev/null | tail -n 1 | sed -E 's/.*HOMEBREW_GITHUB_API_TOKEN=["'\'']?([^"'\''[:space:]]+)["'\'']?.*/\1/' || true)"
        if [[ -n "$tok" && "$tok" != *"YOUR_TOKEN"* ]]; then
            DETECTED_GH_TOKEN="$tok"
            break
        fi
    fi
done

printf "\n${BOLD}======================================================================${RESET}\n"
printf "${BOLD}   Gino's Super Dev Env — Interactive Setup Wizard${RESET}\n"
printf "${BOLD}   (Bash 5.3 + Starship + fzf + tmux 3.7 + Neovim 0.12 + Antigravity)${RESET}\n"
printf "${BOLD}======================================================================${RESET}\n\n"

if [[ "$DRY_RUN" == "true" ]]; then
    warn "Running in --dry-run mode. No files or packages will be modified."
fi

# -----------------------------------------------------------------------------
# 2. Interactive Configuration Questions
# -----------------------------------------------------------------------------
INSTALL_BREW_DEPS=true
if prompt_yes_no "Check and install Homebrew packages (bash, tmux, neovim, starship, fzf, ripgrep, fd, SauceCodePro Nerd Font)?" "y"; then
    INSTALL_BREW_DEPS=true
else
    INSTALL_BREW_DEPS=false
fi

GCP_PROJECT="$(prompt_val "GCP Project ID for Antigravity CLI" "$DEFAULT_GCP_PROJECT")"
GCP_LOCATION="$(prompt_val "GCP Location for Antigravity CLI" "$DEFAULT_GCP_LOCATION")"
WORKSPACE_DIR="$(prompt_val "Primary Repositories / Workspace directory" "$DEFAULT_WORKSPACE_DIR")"
MULTIPLEXER_PROMPT="$(prompt_val "Login shell startup prompt in .bash_profile (tmux / screen / none)" "$DEFAULT_MULTIPLEXER")"

GH_TOKEN="$DETECTED_GH_TOKEN"
if [[ -z "$GH_TOKEN" && "$USE_DEFAULTS" == "false" ]]; then
    read -r -s -p "$(printf "${BOLD}Optional GitHub Personal Access Token for ~/.secrets (leave blank to skip)${RESET}: ")" GH_TOKEN </dev/tty || true
    printf "\n"
elif [[ -n "$GH_TOKEN" ]]; then
    info "Detected existing HOMEBREW_GITHUB_API_TOKEN (will be stored safely in chmod 600 ~/.secrets)"
fi

CONFIGURE_ITERM_FONT=true
if prompt_yes_no "Configure iTerm2 profile font to 'SauceCodeProNF-SemiBold 14' (if iTerm2 is installed)?" "y"; then
    CONFIGURE_ITERM_FONT=true
else
    CONFIGURE_ITERM_FONT=false
fi

# -----------------------------------------------------------------------------
# 3. Install CLI Dependencies & Nerd Font (Fast Prebuilt Binaries + Homebrew)
# -----------------------------------------------------------------------------
install_github_binary() {
    local name="$1"
    local repo="$2"
    local asset_pattern="$3"
    local bin_name="${4:-$name}"
    local dest_dir="$HOME/bin"
    [[ -w "/usr/local/bin" ]] && dest_dir="/usr/local/bin"
    mkdir -p "$dest_dir"

    if command -v "$bin_name" >/dev/null 2>&1; then
        ok "$name ($bin_name) is already installed at $(command -v "$bin_name")."
        return 0
    fi

    info "Installing prebuilt $name binary from GitHub ($repo)..."
    if [[ "$DRY_RUN" == "true" ]]; then
        info "[DRY-RUN] Would download $repo ($asset_pattern) -> $dest_dir/$bin_name"
        return 0
    fi

    local tmpdir
    tmpdir="$(mktemp -d)"
    local url
    url="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" | python3 -c "
import json, re, sys
data = json.load(sys.stdin)
pat = re.compile(sys.argv[1])
for a in data.get('assets', []):
    if pat.search(a['name']):
        print(a['browser_download_url'])
        break
" "$asset_pattern")"

    if [[ -z "$url" ]]; then
        warn "Could not find prebuilt binary URL for $name; skipping."
        rm -rf "$tmpdir"
        return 1
    fi

    curl -fsSL "$url" -o "$tmpdir/archive.tar.gz"
    tar -xzf "$tmpdir/archive.tar.gz" -C "$tmpdir"
    local found_bin
    found_bin="$(find "$tmpdir" -type f -name "$bin_name" | head -n 1)"
    if [[ -n "$found_bin" ]]; then
        cp "$found_bin" "$dest_dir/$bin_name"
        chmod +x "$dest_dir/$bin_name"
        ok "Installed $bin_name -> $dest_dir/$bin_name"
    fi
    rm -rf "$tmpdir"
}

if [[ "$INSTALL_BREW_DEPS" == "true" ]]; then
    ARCH="$(uname -m)"
    if [[ "$ARCH" == "arm64" ]]; then
        STARSHIP_PAT="starship-aarch64-apple-darwin\\.tar\\.gz$"
        FZF_PAT="darwin_arm64\\.tar\\.gz$"
        RG_PAT="aarch64-apple-darwin\\.tar\\.gz$"
        FD_PAT="aarch64-apple-darwin\\.tar\\.gz$"
    else
        STARSHIP_PAT="starship-x86_64-apple-darwin\\.tar\\.gz$"
        FZF_PAT="darwin_amd64\\.tar\\.gz$"
        RG_PAT="x86_64-apple-darwin\\.tar\\.gz$"
        FD_PAT="x86_64-apple-darwin\\.tar\\.gz$"
    fi

    install_github_binary "starship" "starship/starship" "$STARSHIP_PAT" "starship"
    install_github_binary "fzf"      "junegunn/fzf"      "$FZF_PAT"      "fzf"
    install_github_binary "ripgrep"  "BurntSushi/ripgrep" "$RG_PAT"      "rg"
    install_github_binary "fd"       "sharkdp/fd"        "$FD_PAT"       "fd"

    # Install SauceCodePro Nerd Font directly to ~/Library/Fonts if not present
    if ! ls "$HOME/Library/Fonts"/*SauceCodePro* "/Library/Fonts"/*SauceCodePro* >/dev/null 2>&1; then
        info "Installing SauceCodePro Nerd Font into ~/Library/Fonts..."
        if [[ "$DRY_RUN" == "false" ]]; then
            tmpfont="$(mktemp -d)"
            curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz" -o "$tmpfont/SourceCodePro.tar.xz"
            mkdir -p "$HOME/Library/Fonts"
            tar -xJf "$tmpfont/SourceCodePro.tar.xz" -C "$HOME/Library/Fonts"
            rm -rf "$tmpfont"
            ok "Installed SauceCodePro Nerd Font into ~/Library/Fonts"
        fi
    else
        ok "SauceCodePro Nerd Font is already installed."
    fi
fi

# -----------------------------------------------------------------------------
# 4. Back Up Existing Dotfiles to ~/.dev-env-backup/<timestamp>
# -----------------------------------------------------------------------------
TARGET_FILES=(
    ".bash_profile"
    ".bashrc"
    ".alias"
    ".alias_kubectl"
    ".inputrc"
    ".tmux.conf"
    ".screenrc"
    ".vimrc"
    ".config/starship.toml"
    ".config/nvim/init.lua"
    ".gemini/antigravity-cli/settings.json"
    "bin/ade"
)

info "Backing up existing dotfiles to $BACKUP_DIR ..."
for rel in "${TARGET_FILES[@]}"; do
    src="$HOME/$rel"
    if [[ -f "$src" ]]; then
        if [[ "$DRY_RUN" == "true" ]]; then
            info "[DRY-RUN] Would back up $src -> $BACKUP_DIR/$rel"
        else
            mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
            cp -p "$src" "$BACKUP_DIR/$rel"
        fi
    fi
done
[[ "$DRY_RUN" == "false" ]] && ok "Backup saved to $BACKUP_DIR"

# -----------------------------------------------------------------------------
# 5. Create/Update ~/.secrets (chmod 600, untracked)
# -----------------------------------------------------------------------------
SECRETS_FILE="$HOME/.secrets"
if [[ "$DRY_RUN" == "true" ]]; then
    info "[DRY-RUN] Would write $SECRETS_FILE with mode 600"
else
    if [[ ! -f "$SECRETS_FILE" ]]; then
        cp "$REPO_DIR/templates/bash/secrets.example" "$SECRETS_FILE"
    fi
    chmod 600 "$SECRETS_FILE"
    if [[ -n "$GH_TOKEN" ]]; then
        if grep -q "HOMEBREW_GITHUB_API_TOKEN=" "$SECRETS_FILE" 2>/dev/null; then
            python3 -c '
import re, sys
p, tok = sys.argv[1], sys.argv[2]
txt = open(p).read()
txt = re.sub(r"^#?\s*(export\s+)?HOMEBREW_GITHUB_API_TOKEN=.*$", f"export HOMEBREW_GITHUB_API_TOKEN=\"{tok}\"", txt, flags=re.M)
open(p, "w").write(txt)
' "$SECRETS_FILE" "$GH_TOKEN"
        else
            printf '\nexport HOMEBREW_GITHUB_API_TOKEN="%s"\n' "$GH_TOKEN" >> "$SECRETS_FILE"
        fi
        chmod 600 "$SECRETS_FILE"
        ok "Secured HOMEBREW_GITHUB_API_TOKEN in $SECRETS_FILE (chmod 600)"
    fi
fi

# -----------------------------------------------------------------------------
# 6. Render & Install Templates
# -----------------------------------------------------------------------------
install_file() {
    local src="$1"
    local dest="$2"
    if [[ "$DRY_RUN" == "true" ]]; then
        info "[DRY-RUN] Would install $src -> $dest"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    ok "Installed $dest"
}

render_template() {
    local src="$1"
    local dest="$2"
    if [[ "$DRY_RUN" == "true" ]]; then
        info "[DRY-RUN] Would render template $src -> $dest (GCP_PROJECT=$GCP_PROJECT, WORKSPACE_DIR=$WORKSPACE_DIR, MULTIPLEXER=$MULTIPLEXER_PROMPT)"
        return
    fi
    mkdir -p "$(dirname "$dest")"
    python3 -c '
import sys
src, dest, proj, loc, ws, mux = sys.argv[1:7]
content = open(src).read()
content = content.replace("{{GCP_PROJECT}}", proj)
content = content.replace("{{GCP_LOCATION}}", loc)
content = content.replace("{{WORKSPACE_DIR}}", ws)
content = content.replace("{{MULTIPLEXER_PROMPT}}", mux)
open(dest, "w").write(content)
' "$src" "$dest" "$GCP_PROJECT" "$GCP_LOCATION" "$WORKSPACE_DIR" "$MULTIPLEXER_PROMPT"
    ok "Rendered $dest"
}

# Install Bash & Readline configs
render_template "$REPO_DIR/templates/bash/bash_profile.tmpl" "$HOME/.bash_profile"
render_template "$REPO_DIR/templates/bash/bashrc.tmpl"       "$HOME/.bashrc"
render_template "$REPO_DIR/templates/bash/alias.tmpl"        "$HOME/.alias"
install_file    "$REPO_DIR/templates/bash/alias_kubectl"     "$HOME/.alias_kubectl"
install_file    "$REPO_DIR/templates/bash/inputrc"           "$HOME/.inputrc"

# Install Starship prompt config
install_file    "$REPO_DIR/templates/starship/starship.toml" "$HOME/.config/starship.toml"

# Install tmux & screen configs
install_file    "$REPO_DIR/templates/tmux/tmux.conf"         "$HOME/.tmux.conf"
install_file    "$REPO_DIR/templates/tmux/screenrc"          "$HOME/.screenrc"

# Install Neovim & classic Vim configs
install_file    "$REPO_DIR/templates/nvim/init.lua"          "$HOME/.config/nvim/init.lua"
install_file    "$REPO_DIR/templates/nvim/vimrc"             "$HOME/.vimrc"

# Install ade launcher script
install_file    "$REPO_DIR/bin/ade"                          "$HOME/bin/ade"
[[ "$DRY_RUN" == "false" ]] && chmod +x "$HOME/bin/ade"

# Install / Merge Antigravity CLI settings.json
if [[ "$DRY_RUN" == "true" ]]; then
    info "[DRY-RUN] Would update $EXISTING_AGY_SETTINGS with editor=nvim, project=$GCP_PROJECT"
else
    mkdir -p "$(dirname "$EXISTING_AGY_SETTINGS")"
    python3 -c '
import json, os, sys
tmpl_path, target_path, proj, loc, ws, repo_parent = sys.argv[1:7]
base = json.load(open(tmpl_path))
base.pop("_comment", None)
existing = {}
if os.path.exists(target_path):
    try:
        existing = json.load(open(target_path))
    except Exception:
        existing = {}

merged = {**base, **existing}
merged["editor"] = "nvim"
merged["editorMode"] = "vim"
merged["gcp"] = {"project": proj, "location": loc}

trusted = list(existing.get("trustedWorkspaces", []))
for path in [ws, os.path.join(repo_parent, "dev-env")]:
    if path and path not in trusted:
        trusted.append(path)
merged["trustedWorkspaces"] = trusted

with open(target_path, "w") as f:
    json.dump(merged, f, indent=2)
    f.write("\n")
' "$REPO_DIR/templates/antigravity/settings.json.tmpl" "$EXISTING_AGY_SETTINGS" "$GCP_PROJECT" "$GCP_LOCATION" "$WORKSPACE_DIR" "$(dirname "$REPO_DIR")"
    ok "Updated Antigravity CLI settings at $EXISTING_AGY_SETTINGS"
fi

# -----------------------------------------------------------------------------
# 7. Update iTerm2 Font to SauceCodeProNF-SemiBold 14 (if requested)
# -----------------------------------------------------------------------------
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [[ "$CONFIGURE_ITERM_FONT" == "true" && -f "$ITERM_PLIST" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
        info "[DRY-RUN] Would update iTerm2 Normal Font / Non Ascii Font to 'SauceCodeProNF-SemiBold 14'"
    else
        python3 -c '
import plistlib, sys
p = sys.argv[1]
with open(p, "rb") as f:
    data = plistlib.load(f)
for bm in data.get("New Bookmarks", []):
    bm["Normal Font"] = "SauceCodeProNF-SemiBold 14"
    bm["Non Ascii Font"] = "SauceCodeProNF-SemiBold 14"
with open(p, "wb") as f:
    plistlib.dump(data, f)
' "$ITERM_PLIST" 2>/dev/null && ok "Updated iTerm2 profile font to 'SauceCodeProNF-SemiBold 14'" || warn "Could not auto-update iTerm2 plist; set font manually in iTerm2 -> Settings -> Profiles -> Text."
    fi
fi

# -----------------------------------------------------------------------------
# 8. Bootstrap Neovim Plugins Headlessly
# -----------------------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
    if [[ "$DRY_RUN" == "true" ]]; then
        info "[DRY-RUN] Would bootstrap Neovim lazy.nvim plugins headlessly"
    else
        info "Bootstrapping Neovim 0.12 plugins (lazy.nvim, telescope, gitsigns, oil)..."
        nvim --headless "+Lazy! sync" +qa >/dev/null 2>&1 || true
        ok "Neovim 0.12 plugins synced."
    fi
fi

printf "\n${GREEN}${BOLD}======================================================================${RESET}\n"
printf "${GREEN}${BOLD}   Gino's Super Dev Env Installation Complete!${RESET}\n"
printf "${GREEN}${BOLD}======================================================================${RESET}\n"
printf "Next steps:\n"
printf "  1. Reload your shell:  ${CYAN}source ~/.bash_profile${RESET}\n"
printf "  2. Launch IDE layout:  ${CYAN}ade${RESET} (or ${CYAN}tdev${RESET})\n"
printf "  3. Backup location:    ${CYAN}%s${RESET}\n\n" "$BACKUP_DIR"
