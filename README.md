# Gino's Super Dev Env (`dev-env`)

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

A fast, keyboard-driven command-line development environment for **macOS** (`arm64` & `x86_64`) and **Linux** (`x86_64` & `arm64`/`aarch64`) that pairs **Bash 5+ + Starship + `fzf`**, **`tmux` 3.x+**, **Neovim 0.12+**, and **Antigravity CLI (`agy`)** while honoring decades of classic **`vi`** and **GNU `screen`** muscle memory.

Clone this repository onto any brand-new Mac or Linux computer and run `./install.sh` to bootstrap the entire stack in under a minute.

> 📖 **Documentation Map**:
> - **[`README.md`](README.md)** *(this file)* — Detailed installation guide, hands-on walkthrough, and keyboard shortcut cheatsheets.
> - **[`TUTORIAL.md`](TUTORIAL.md)** — **Complete Toolset Training Course**: Deep-dive tutorial on every newly installed program (`bash 5+`, `starship`, `fzf`, `rg`, `fd`, `tmux`, `nvim 0.12+`, `agy` + `ade`, and `dev-copy`), why each feature boosts productivity, and hands-on exercises.
> - **[`WALKTHROUGH.md`](WALKTHROUGH.md)** — Focused post-install tour and verification checklist.
> - **[`ARCHITECTURE.md`](ARCHITECTURE.md)** — Deep technical implementation details (terminal escape sequences, Readline `\1...\2` prompt escapes, `tmux` TTY inspection, and the Neovim ➔ `agy` IPC bridge).

---

## ✨ What's Inside

| Layer | Tooling | Highlights |
| :--- | :--- | :--- |
| **Shell & Prompt** | **Bash 5.3** + **Starship** + **Readline** + **`fzf`** | Two-line developer prompt with **SauceCodePro Nerd Font** icons, smart Git-root truncation, Git dirty/staged/ahead-behind badges, active runtime/venv versions, slow-command timer (`>2s`), SSH-only `user@host`, live `[I]`/`[N]` `vi`-mode badge with beam/block cursor switching, and `Ctrl-R` fuzzy history search. |
| **Multiplexer** | **`tmux` 3.x+** (plus classic `.screenrc`) | Uses `Ctrl-a` prefix just like GNU `screen`, `100,000` line scrollback, `K` to kill, `Escape` for `vi` copy-mode (yanks via universal `bin/dev-copy` to macOS `pbcopy`, Linux `wl-copy`/`xclip`, and SSH OSC 52), bottom `[ host ][ windows ][ loadavg ][ date time ]` bar, seamless `Ctrl-h/j/k/l` navigation with Neovim, and `Ctrl-a g` floating popup for `agy`. |
| **Editor** | **Neovim 0.12+** (plus classic `.vimrc`) | Single-file `~/.config/nvim/init.lua` preserving classic `.vimrc` preferences (`4`-space tabs, `mouse=""` disabled for clean terminal copy/paste, cursor restore, `:DiffOrig`) + persistent undo, live `:%s` preview, Treesitter, Telescope (`<Space>ff`, `<Space>fg`), Gitsigns, Oil (`-`), and real-time `agy` buffer auto-reload. |
| **AI Agent Bridge** | **Antigravity CLI (`agy`)** + **`ade`** | Launch a full side-by-side `nvim` + `agy` workspace with `ade` (or `tdev`), summon a floating `agy` popup with `Ctrl-a g`, and send `@file` or `@file#L10-L25` selections straight from Neovim to `agy` with `<Space>af` and `<Space>as` (with smart shell fallback if `agy` is not yet installed). |

---

## 🖥️ Supported Platforms

| OS | Architectures | Package & Binary Strategy |
| :--- | :--- | :--- |
| **macOS** | Apple Silicon (`arm64`) & Intel (`x86_64`) | Auto-installs Homebrew (if missing) for `bash` 5.x & `tmux`, plus fast prebuilt release binaries for `neovim` 0.12+, `starship`, `fzf`, `rg`, `fd`, and `SauceCodePro Nerd Font` (`~/Library/Fonts`). |
| **Linux** | `x86_64` (`amd64`) & `arm64` (`aarch64`) | **Hybrid Privilege Model**: Uses `sudo` with `apt-get`, `dnf`, `yum`, `pacman`, or `apk` when available for core packages (`bash`, `tmux`, `git`, `curl`, `jq`, `fontconfig`, `xclip`), and automatically falls back to rootless `~/.local/bin` / `~/.local` prebuilt binaries (`neovim` 0.12+, `starship`, `fzf`, `rg`, `fd`, and `~/.local/share/fonts`). |

---

## 🚀 Detailed Installation Guide (New Computer Bootstrap)

Whether you are setting up a brand-new MacBook, a Linux desktop workstation, or a remote cloud VM/container, the installation process is always two steps: **clone the repo** and **run `./install.sh`**.

---

### Prerequisites

- **Operating System**:
  - **macOS** 12+ (Apple Silicon `arm64` or Intel `x86_64`)
  - **Linux** (`x86_64` / `amd64` or `arm64` / `aarch64`) — tested with Debian/Ubuntu (`apt`), Fedora/RHEL/Rocky (`dnf`/`yum`), Arch (`pacman`), Alpine (`apk`), and rootless Linux environments without `sudo`.
- **Minimal Base Tools**:
  - `git` and `curl` (plus `tar`).
  - *On a brand-new Mac*: Running `git` in Terminal for the first time will automatically prompt macOS to install the Xcode Command Line Tools (`xcode-select --install`).
  - *On a minimal Linux server*: Ensure `git` and `curl` are present (`sudo apt-get update && sudo apt-get install -y git curl` on Debian/Ubuntu).

---

### Step 1: Clone the Repository

Clone `dev-env` into `~/Repositories/dev-env` (or any directory you prefer):

```bash
mkdir -p ~/Repositories
# Using SSH (if your SSH key is already registered with GitHub):
git clone git@github.com:gfilicetti/dev-env.git ~/Repositories/dev-env

# Or using HTTPS (works immediately on a fresh machine before setting up SSH keys):
git clone https://github.com/gfilicetti/dev-env.git ~/Repositories/dev-env

cd ~/Repositories/dev-env
```

---

### Step 2: Run the Interactive Installer (`./install.sh`)

```bash
./install.sh
```

When you run `./install.sh`, the interactive wizard walks you through **6 quick configuration questions** (each pre-filled with a smart default or auto-detected from your existing machine so you can simply press `Enter`):

| Prompt | Default | What It Configures |
| :--- | :--- | :--- |
| **1. Install/verify core packages & CLI tools?** | `Y` | Installs/verifies `bash` 5+, `tmux`, `neovim` 0.12+, `starship`, `fzf`, `ripgrep` (`rg`), `fd`, and `SauceCodePro Nerd Font`. |
| **2. GCP Project ID for Antigravity CLI** | Auto-detected or `your-gcp-project-id` | Populates `gcp.project` in `~/.gemini/antigravity-cli/settings.json`. |
| **3. GCP Location for Antigravity CLI** | `global` | Populates `gcp.location` in `~/.gemini/antigravity-cli/settings.json`. |
| **4. Primary Repositories / Workspace directory** | `~/Repositories` | Adds your workspace root to `trustedWorkspaces` in `~/.gemini/antigravity-cli/settings.json`. |
| **5. Login shell startup prompt in `.bash_profile`** | `tmux` | Controls whether new login shells offer a 5-second `Start tmux? (y/N)` prompt (`tmux`), `Start screen? (y/N)` (`screen`), or no prompt (`none`). |
| **6. Optional GitHub Personal Access Token** | *(Hidden input / skip)* | If provided (or already present on disk), writes `HOMEBREW_GITHUB_API_TOKEN` exclusively to untracked `~/.secrets` with `chmod 600` permissions. |
| **7. Configure iTerm2 profile font?** *(macOS only)* | `Y` | Updates `~/Library/Preferences/com.googlecode.iterm2.plist` so iTerm2 uses `SauceCodeProNF-SemiBold 14`. |

---

### Step 3: What `./install.sh` Does Under the Hood (macOS vs. Linux)

#### On macOS (`arm64` & `x86_64`)
1. **Homebrew Bootstrap**: Checks if `brew` is installed (`/opt/homebrew/bin/brew` or `/usr/local/bin/brew`). If missing on a brand-new Mac, offers to install Homebrew automatically.
2. **Core Packages**: Ensures modern **Bash 5.x** (replacing macOS's ancient 2007 `/bin/bash` 3.2), **`tmux`**, **`git`**, **`curl`**, **`jq`**, and **`python3`** are installed via Homebrew.
3. **Fast Prebuilt Binaries**: Downloads official prebuilt release binaries directly from GitHub Releases for **Neovim 0.12+** (`~/.local/nvim/bin/nvim` linked to `~/bin/nvim`), **`starship`**, **`fzf`**, **`ripgrep` (`rg`)**, and **`fd`**—avoiding slow source builds on newer macOS versions.
4. **Nerd Font & iTerm2**: Installs **SauceCodePro Nerd Font** into `~/Library/Fonts` and configures your iTerm2 profile font to `SauceCodeProNF-SemiBold 14`.

#### On Linux (`x86_64` & `arm64`/`aarch64`)
1. **Hybrid Privilege Model (`sudo` + Rootless Fallback)**:
   - **With `sudo`**: Detects `apt-get`, `dnf`, `yum`, `pacman`, or `apk` and installs `bash`, `bash-completion`, `tmux`, `git`, `curl`, `jq`, `tar`, `xz`, `unzip`, `fontconfig`, `xclip`, `wl-clipboard`, and `python3`.
   - **Without `sudo` (Rootless / Shared Server)**: Automatically skips the system package manager and installs all CLI binaries into `~/.local/bin` and `~/bin` with zero root privileges required.
2. **Official Prebuilt Neovim 0.12+**: Many Linux distros (such as Ubuntu/Debian `apt`) ship outdated Neovim `0.6`–`0.9` packages that lack modern Lua APIs. `./install.sh` automatically downloads the official `nvim-linux-{x86_64,arm64}.tar.gz` release into `~/.local/nvim` and links it to `~/bin/nvim` and `~/.local/bin/nvim`.
3. **Static Prebuilt Rust Tools**: Downloads static `musl`/`gnu` Linux binaries for **`starship`**, **`fzf`**, **`ripgrep` (`rg`)**, and **`fd`**.
4. **Fontconfig Integration**: Installs **SauceCodePro Nerd Font** into `~/.local/share/fonts` and runs `fc-cache -f` so GUI Linux terminals immediately recognize the glyphs.

---

### Step 4: Installed File Map & Automatic Backups

Before modifying any file in your home directory, `./install.sh` creates a timestamped snapshot of your existing dotfiles in:
```text
~/.dev-env-backup/<YYYYMMDD-HHMMSS>/
```

It then installs the following files:

| Destination Path in `$HOME` | Source in Repository | Purpose |
| :--- | :--- | :--- |
| `~/.bash_profile` | `templates/bash/bash_profile.tmpl` | Login shell startup, PATH, Homebrew/Linux completions, `gcloud` SDK, `~/.secrets` loader, optional `tmux` prompt. |
| `~/.bashrc` | `templates/bash/bashrc.tmpl` | Interactive shell config: `EDITOR=nvim`, 100k deduplicated history, `set -o vi`, `fzf`, and Starship init. |
| `~/.alias` | `templates/bash/alias.tmpl` | Portable Mac & Linux aliases (`tdev`, `clip`, `l`, `update`, `pf`, `ducks`, Git shortcuts). |
| `~/.alias_kubectl` | `templates/bash/alias_kubectl` | Comprehensive `kubectl` shortcut aliases (`k`, `kgpo`, `klo`, etc.). |
| `~/.inputrc` | `templates/bash/inputrc` | GNU Readline `vi`-mode `[I]`/`[N]` prompt badge, beam/block cursor shape switching, and prefix history search. |
| `~/.secrets` *(chmod 600)* | `templates/bash/secrets.example` | Untracked private file for `HOMEBREW_GITHUB_API_TOKEN` and sensitive API keys. |
| `~/.config/starship.toml` | `templates/starship/starship.toml` | Two-line developer prompt configuration. |
| `~/.tmux.conf` | `templates/tmux/tmux.conf` | `tmux` 3.x+ config (`Ctrl-a` prefix, `dev-copy` clipboard, `Ctrl-h/j/k/l` navigation, `Ctrl-a g` `agy` popup). |
| `~/.screenrc` | `templates/tmux/screenrc` | Classic GNU `screen` fallback configuration. |
| `~/.config/nvim/init.lua` | `templates/nvim/init.lua` | Single-file Neovim 0.12+ config (Telescope, Gitsigns, Oil, Treesitter, and `agy` IPC bridge). |
| `~/.vimrc` | `templates/nvim/vimrc` | Classic Vim fallback configuration. |
| `~/.gemini/antigravity-cli/settings.json` | `templates/antigravity/settings.json.tmpl` | Antigravity CLI config (`editor: "nvim"`, `editorMode: "vim"`, GCP project, `trustedWorkspaces`). |
| `~/bin/ade` | `bin/ade` | Launches the 2-window `tmux` + `nvim` + `agy` workspace (aliased to `tdev`). |
| `~/bin/dev-copy` | `bin/dev-copy` | Universal clipboard helper supporting `pbcopy`, `wl-copy`, `xclip`/`xsel`, and SSH OSC 52 (aliased to `clip`). |

---

### Step 5: Terminal Font & Login Shell Finalization

1. **Terminal Emulator Font**:
   - **iTerm2 on macOS**: Automatically configured by `./install.sh` (`SauceCodeProNF-SemiBold 14`). Restart iTerm2 (or open a new window) after installing on a fresh machine for the font change to take effect.
   - **Other Terminal Emulators** (macOS Terminal.app, Ghostty, WezTerm, Alacritty, Kitty, GNOME Terminal, or Windows Terminal when SSHing into a Linux box): Set your terminal profile font to **`SauceCodePro Nerd Font`** (size `13` or `14`) so Git branch (``) and file tree icons render cleanly.
2. **Default Login Shell (`bash`)**:
   - On macOS (where `/bin/zsh` is the factory default) or Linux machines defaulting to `/bin/sh`, `./install.sh` detects if `$SHELL` is not `bash` and offers to switch your login shell via `chsh -s`.
   - You can also switch manually anytime:
     ```bash
     # macOS (Apple Silicon):
     chsh -s /opt/homebrew/bin/bash
     # macOS (Intel):
     chsh -s /usr/local/bin/bash
     # Linux:
     chsh -s /bin/bash
     ```
3. **Reload Your Current Shell**:
   ```bash
   source ~/.bash_profile
   ```

---

### Step 6: Installer Modes (Non-Interactive, Dry-Run & Rollback)

```bash
# 1. Interactive setup wizard (recommended for first run on a new computer)
./install.sh

# 2. Non-interactive install using auto-detected/default values (great for scripts/CI)
./install.sh --defaults

# 3. Preview all package checks, backups, and template renders without modifying disk
./install.sh --dry-run

# 4. Instant rollback: restore all dotfiles from the latest ~/.dev-env-backup/<timestamp>
./install.sh --uninstall
```

---

## 🎓 New to the Toolset? Read [`TUTORIAL.md`](TUTORIAL.md)!

Want to learn *why* each newly installed tool (`starship`, `fzf`, `ripgrep`, `fd`, `tmux`, `nvim 0.12+`, `agy`, and `dev-copy`) is so productive and practice hands-on exercises for every feature?
👉 **Open [`TUTORIAL.md`](TUTORIAL.md) for the complete self-paced training guide.**

---

## 🧭 Hands-On Walkthrough & Key Chords to Try Right Away

### Step 1: Reload Your Shell & Test the Prompt
Open a new iTerm2 tab or reload your current shell:
```bash
cd ~/Repositories/dev-env
source ~/.bash_profile
```
Try these immediately at the Bash prompt:
- **Toggle `vi` modes (`Esc` vs `i`)**: Press `<Esc>` on the command line—watch the green `[I]` badge and thin beam cursor (`|`) immediately switch to a cyan `[N]` badge and solid block cursor (`█`). Press `i` to return to Insert mode.
- **Fuzzy History Search (`Ctrl-R` or `/` in `[N]` mode)**: Press `Ctrl-R` (or `<Esc>` then `/`) to launch an interactive `fzf` search over 100,000 deduplicated history commands.
- **Fuzzy File Insert (`Ctrl-T`)**: Type `nvim ` and press `Ctrl-T` to fuzzy-pick any file in the repo and insert its path onto the command line.

### Step 2: Launch Your Side-by-Side `nvim` + `agy` Workspace (`ade` / `tdev`)
From any repository directory, run:
```bash
ade                  # Opens tmux session for current directory (62% nvim | 38% agy + shell window)
ade ~/Repositories/x # Opens or attaches to tmux session for target repository
ade -p               # Popup-only mode: full-screen Neovim, summon agy anytime with Ctrl-a g
```
This creates (or reattaches to) a `tmux` session named `dev-<repo-name>` with two windows:
- **Window 0 (`code`)**: Split into **Neovim 0.12** on the left (`62%`) and **Antigravity CLI (`agy`)** on the right (`38%`).
- **Window 1 (`shell`)**: A full-screen Bash 5.3 + Starship shell in the project root.

### Step 3: Essential Key Chords to Remember
- **`Ctrl-h` / `Ctrl-l`**: Jump seamlessly between Neovim (left pane) and `agy` (right pane) without needing `Ctrl-a`.
- **`Ctrl-a Ctrl-a`**: Flip between Window 0 (`code`) and Window 1 (`shell`), identical to GNU `screen`.
- **`Ctrl-a z`**: Zoom/unzoom the current pane (e.g., make Neovim or `agy` temporarily full-screen).
- **`Ctrl-a g`**: Pop up or dismiss a floating `85% x 85%` `agy` overlay from anywhere.
- **`<Space>ff` / `<Space>fg` (in `nvim`)**: Fuzzy-find files by name or live-grep across the repo with `ripgrep`.
- **`<Space>af` (Normal) / `<Space>as` (Visual in `nvim`)**: Send `@file` or `@file#L10-L25` directly into the `agy` prompt and focus `agy`.
- **`]c` / `[c` & `<Space>hp` (in `nvim`)**: When `agy` edits a file, Neovim auto-reloads it immediately—use `]c` / `[c` to jump between modified Git hunks and `<Space>hp` to preview the inline diff.

---

## ⌨️ Complete Keyboard Reference Tables

### 1. GNU `screen` ➔ `tmux` Keybindings (Prefix: `Ctrl-a`)

| Action | Key Chord | Notes |
| :--- | :--- | :--- |
| **Toggle last active window** | `Ctrl-a Ctrl-a` | Identical to `screen` |
| **Send literal `Ctrl-a`** | `Ctrl-a a` | Increments numbers in `nvim` or jumps to start of line |
| **New window (current dir)** | `Ctrl-a c` | Opens Bash 5.3 in the current pane's directory |
| **Interactive window list** | `Ctrl-a "` or `Ctrl-a w` | Visual tree preview of all sessions & windows |
| **Rename current window** | `Ctrl-a A` | Identical to `screen` |
| **Kill current pane/window** | `Ctrl-a K` | Prompts for `(y/n)` confirmation (from `.screenrc`) |
| **Split horizontally (left/right)**| `Ctrl-a \|` or `Ctrl-a h` | Preserves current working directory |
| **Split vertically (top/bottom)** | `Ctrl-a -` or `Ctrl-a v` | Preserves current working directory |
| **Seamless pane/split move** | `Ctrl-h / j / k / l` | **No `Ctrl-a` needed!** Moves across `nvim` splits & `tmux` panes |
| **Cycle panes** | `Ctrl-a Ctrl-s` or `Tab` | Matches your classic `.tmux.conf` |
| **Resize pane** | `Ctrl-a H / J / K / L` | Repeatable 5-cell resize |
| **Zoom / unzoom current pane** | `Ctrl-a z` | Toggle full-screen on either `nvim` or `agy` |
| **Enter `vi` copy mode** | `Ctrl-a Esc` or `Ctrl-a [` | `v` starts selection, `y` or `Enter` copies via `~/bin/dev-copy` (macOS/Linux/SSH OSC 52) |
| **Detach session** | `Ctrl-a d` | Reattach with `tmux attach` or `ade` |
| **Reload `~/.tmux.conf`** | `Ctrl-a r` | Live reload without restarting `tmux` |

---

### 2. Antigravity CLI (`agy`) Integration Shortcuts

| Where | Key Chord | What It Does |
| :--- | :--- | :--- |
| **Anywhere in `tmux`** | `Ctrl-a g` | **Toggle Floating `agy` Popup (`85% x 85%`)** attached to a persistent per-repo `agy` session |
| **Anywhere in `tmux`** | `Ctrl-a G` | **Open Side-by-Side `agy` Pane (`38%` right split)** in the current directory |
| **Neovim (Normal mode)** | `<Space>af` | **Send `@file`** path of current buffer directly into the `agy` pane and focus `agy` |
| **Neovim (Visual mode)** | `<Space>as` | **Send `@file#L10-L25`** line-range selection into the `agy` pane and focus `agy` |
| **Neovim (Automatic)** | *(On disk change)* | **Auto-reloads buffer** as soon as `agy` modifies a file on disk |

---

### 3. Classic `vi` ➔ Neovim 0.12 Upgrades (`Leader` = `<Space>`)

| Action | Key Chord | Description |
| :--- | :--- | :--- |
| **Find files by name** | `<Space>ff` | Telescope fuzzy file finder (powered by `fd` / `rg`) |
| **Live grep across repo** | `<Space>fg` | Instant regex/fuzzy search across project contents |
| **Switch open buffers** | `<Space>fb` | Fuzzy search currently open buffers |
| **Recent files** | `<Space>fr` | Jump to recently edited files |
| **Edit directory as buffer** | `-` | Opens parent directory in `oil.nvim` (rename/delete files like text, `:w` to save) |
| **Next / Prev Git hunk** | `]c` / `[c` | Jump between lines changed by you or `agy` |
| **Preview / Reset Git hunk** | `<Space>hp` / `<Space>hr` | Inline diff popup or revert hunk under cursor |
| **Diff unsaved buffer vs disk**| `:DiffOrig` | Your classic `.vimrc` side-by-side diff command |
| **Live substitution preview** | `:%s/old/new/g` | Splits a live preview window as you type the replacement |
| **Clear search highlight** | `<Esc>` | Clears `hlsearch` highlighting in Normal mode |

---

### 4. Bash 5.3 + Starship + Readline `vi` Mode + `fzf`

| Action | Key Chord | Description |
| :--- | :--- | :--- |
| **Switch to `vi` Normal mode** | `<Esc>` | Prompt badge changes from green `[I]` (`\|` bar cursor) to cyan `[N]` (`█` block cursor) |
| **Fuzzy search history** | `Ctrl-R` (or `/` in `[N]`) | Interactive `fzf` search over 100,000 deduplicated history commands |
| **Fuzzy insert file path** | `Ctrl-T` | Pick file(s) with `fzf` and insert onto current command line |
| **Fuzzy `cd` into subdirectory**| `Alt-C` (or `Esc c`) | Pick a directory with `fzf` and `cd` into it |
| **Prefix history search** | `Up` / `Down` (or `k` / `j`) | Cycles through history matching what you have already typed |

---

## 🔒 Customizing Secrets & Local Overrides

This repository is designed so you never accidentally commit credentials or machine-specific paths:

1. **Private API Keys & Tokens (`~/.secrets`)**:
   - Stored in `~/.secrets` with `chmod 600` permissions (ignored by Git).
   - Put `export HOMEBREW_GITHUB_API_TOKEN="..."` or cloud API keys here.
   - See [`templates/bash/secrets.example`](templates/bash/secrets.example) for the template.
2. **Machine-Local Shell Customizations (`~/.bashrc.local`)**:
   - Automatically sourced at the end of `~/.bashrc` if present.
   - Use it for work-specific aliases, VPN helpers, or custom SDK paths that shouldn't live in the public repo.

---

## ✅ Environment Verification Checklist

Run these checks anytime to confirm all tools and configurations are healthy:

```bash
# 1. Verify CLI binaries
starship --version && fzf --version && rg --version && fd --version && nvim --version | head -n 1

# 2. Verify ~/.secrets permissions (must be 600 on both macOS and Linux)
(stat -f '%Lp' ~/.secrets 2>/dev/null || stat -c '%a' ~/.secrets)

# 3. Verify universal clipboard helper (bin/dev-copy)
echo "dev-env-ok" | ~/bin/dev-copy

# 4. Verify tmux configuration syntax
tmux -L test-dev-env -f ~/.tmux.conf new-session -d -s test_sess \; kill-server

# 5. Verify Neovim 0.12+ & plugins load cleanly
nvim --headless -c 'lua assert(pcall(require, "telescope")); assert(pcall(require, "gitsigns")); assert(pcall(require, "oil")); print("OK")' -c 'qa'
```

---

## 📂 Repository Structure

```text
dev-env/
├── README.md                              # Overview, detailed installation guide & cheatsheets
├── TUTORIAL.md                            # Complete training guide & exercises for the new toolset
├── WALKTHROUGH.md                         # Step-by-step tour & verification checklist
├── ARCHITECTURE.md                        # Deep technical architecture & IPC details
├── AGENTS.md                              # Persistent Antigravity workspace rules for dev-env
├── LICENSE                                # Apache License, Version 2.0
├── NOTICE                                 # Copyright & third-party attribution notices
├── CONTRIBUTING.md                        # Contribution & verification guidelines
├── CODE_OF_CONDUCT.md                     # Contributor Covenant Code of Conduct
├── SECURITY.md                            # Security policy & secret isolation design
├── CHANGELOG.md                           # Release history
├── install.sh                             # Turnkey macOS & Linux installer, backup & template renderer
├── bin/
│   ├── ade                                # Antigravity Dev Environment tmux workspace launcher
│   └── dev-copy                           # Universal clipboard helper (pbcopy, wl-copy, xclip, OSC 52)
└── templates/
    ├── bash/
    │   ├── bash_profile.tmpl              # Login shell config (loads ~/.bashrc, ~/.alias, ~/.secrets)
    │   ├── bashrc.tmpl                    # Interactive Bash 5.3 config (nvim, fzf, Starship, 100k history)
    │   ├── alias.tmpl                     # Portable shell aliases & functions
    │   ├── alias_kubectl                  # Standard kubectl aliases
    │   ├── inputrc                        # Readline vi-mode [I]/[N] indicator & cursor shape control
    │   └── secrets.example                # Documented template for ~/.secrets
    ├── starship/
    │   └── starship.toml                  # Two-line developer prompt configuration
    ├── tmux/
    │   ├── tmux.conf                      # Modern tmux 3.7+ configuration (Ctrl-a prefix + agy popups)
    │   └── screenrc                       # Classic GNU Screen configuration
    ├── nvim/
    │   ├── init.lua                       # Single-file Neovim 0.12 configuration + agy bridge
    │   └── vimrc                          # Classic Vim configuration
    └── antigravity/
        └── settings.json.tmpl             # Scrubbed Antigravity CLI configuration template
```

---

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md) before submitting a pull request.

---

## 📄 License

Copyright 2026 The Gino's Super Dev Env Authors.

Licensed under the **Apache License, Version 2.0** (the "License"); you may not use this project except in compliance with the License. See [LICENSE](LICENSE) and [NOTICE](NOTICE) for full details.

