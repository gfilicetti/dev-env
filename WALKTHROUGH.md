# Walkthrough: Gino's Super Dev Env (`dev-env`)

This walkthrough guides you through what **Gino's Super Dev Env** installs, how each layer is verified, and a hands-on tour of the daily workflow and key chords.

---

## 1. What Gets Installed & Configured

### A. Repository Files (`~/Repositories/dev-env`)
- **[`README.md`](README.md)**: Complete guide for **Gino's Super Dev Env**, including detailed macOS & Linux installation instructions, installer flags, step-by-step walkthrough, and keyboard cheatsheets for `screen` ➔ `tmux`, `vi` ➔ `nvim 0.12`, `agy` integration, and Bash 5+ + Starship + `fzf`.
- **[`TUTORIAL.md`](TUTORIAL.md)**: Comprehensive self-paced training guide taking new users through every installed program (`bash 5+`, `starship`, `fzf`, `rg`, `fd`, `tmux`, `nvim 0.12+`, `ade`/`agy`, and `dev-copy`), why each feature boosts productivity, and hands-on exercises.
- **[`ARCHITECTURE.md`](ARCHITECTURE.md)**: Deep technical architecture documentation explaining terminal escape sequences, DECSCUSR cursor-shape passthrough, Readline zero-width prompt escapes (`\1...\2`), `tmux` TTY process inspection (`is_vim`), and Neovim's `agy` auto-reload & `send-keys` bridge.
- **[`install.sh`](install.sh)**: Turnkey macOS & Linux setup wizard supporting `./install.sh`, `./install.sh --defaults`, `./install.sh --dry-run`, and `./install.sh --uninstall` (instant rollback from `~/.dev-env-backup/<timestamp>`).
- **[`bin/ade`](bin/ade)**: Workspace launcher script (also aliased to `tdev`) that starts or attaches to a per-repo `tmux` session with Neovim (left 62%), Antigravity CLI `agy` (right 38%, with automatic fallback to an interactive Bash shell if `agy` is not installed yet), and a secondary Bash shell window.
- **[`bin/dev-copy`](bin/dev-copy)**: Universal clipboard helper (also aliased to `clip`) that pipes `tmux` `copy-mode-vi` yanks and standard input to macOS `pbcopy`, Linux Wayland `wl-copy`, Linux X11 `xclip`/`xsel`, and remote SSH terminals via ANSI OSC 52 escape sequences.
- **Scrubbed Templates (`templates/`)**:
  - [`templates/bash/bash_profile.tmpl`](templates/bash/bash_profile.tmpl), [`bashrc.tmpl`](templates/bash/bashrc.tmpl), [`alias.tmpl`](templates/bash/alias.tmpl), [`alias_kubectl`](templates/bash/alias_kubectl), [`inputrc`](templates/bash/inputrc), and [`secrets.example`](templates/bash/secrets.example)
  - [`templates/starship/starship.toml`](templates/starship/starship.toml)
  - [`templates/tmux/tmux.conf`](templates/tmux/tmux.conf) & [`screenrc`](templates/tmux/screenrc)
  - [`templates/nvim/init.lua`](templates/nvim/init.lua) & [`vimrc`](templates/nvim/vimrc)
  - [`templates/antigravity/settings.json.tmpl`](templates/antigravity/settings.json.tmpl)

### B. Live Environment Deployed (`~/`)
- **Prebuilt Binaries & Nerd Font Installed**:
  - `starship` (`/usr/local/bin/starship`) — Two-line Rust-powered prompt
  - `fzf` (`/usr/local/bin/fzf`) — Interactive fuzzy finder for command history (`Ctrl-R`) and files (`Ctrl-T`)
  - `ripgrep` (`/usr/local/bin/rg`) — Fast regex search engine for Neovim Telescope & CLI
  - `fd` (`/usr/local/bin/fd`) — Fast file finder for Neovim Telescope & CLI
  - `SauceCodePro Nerd Font` (`~/Library/Fonts/SauceCodeProNerdFont-*.ttf`), with iTerm2 profile font updated to `SauceCodeProNF-SemiBold 14`
- **Secrets Isolated**:
  - Private tokens (such as `HOMEBREW_GITHUB_API_TOKEN`) are isolated in `~/.secrets` with `chmod 600` permissions and never tracked in Git.
- **Dotfiles Backed Up & Installed**:
  - Previous dotfiles are automatically backed up to `~/.dev-env-backup/<YYYYMMDD-HHMMSS>/`.
  - Live configs deployed to `~/.bash_profile`, `~/.bashrc`, `~/.alias`, `~/.inputrc`, `~/.config/starship.toml`, `~/.tmux.conf`, `~/.config/nvim/init.lua`, `~/bin/ade`, and `~/.gemini/antigravity-cli/settings.json`.

---

## 2. Step-by-Step Hands-On Walkthrough

### Step 1: Reload Your Shell & Test the Prompt
Open a new iTerm2 tab or reload your shell:
```bash
cd ~/Repositories/dev-env
source ~/.bash_profile
```
What to try right away at the Bash prompt:
1. **Toggle `vi` modes (`Esc` vs `i`)**: Press `<Esc>` on the command line—watch the green `[I]` badge and thin beam cursor (`|`) immediately switch to a cyan `[N]` badge and solid block cursor (`█`). Press `i` to return to Insert mode.
2. **Fuzzy History Search (`Ctrl-R` or `/` in `[N]` mode)**: Press `Ctrl-R` (or hit `<Esc>` then `/`) to launch `fzf` over your 100,000-line deduplicated command history.
3. **Fuzzy File Insert (`Ctrl-T`)**: Type `nvim ` and press `Ctrl-T` to fuzzy-pick any file in the repo and insert its path onto the command line.

### Step 2: Launch the Full IDE Layout (`ade` / `tdev`)
From inside any project repository, run:
```bash
ade
```
This creates (or reattaches to) a `tmux` session named `dev-<repo-name>` with two windows:
- **Window 0 (`code`)**: Split into **Neovim 0.12** on the left (`62%`) and **Antigravity CLI (`agy`)** on the right (`38%`).
- **Window 1 (`shell`)**: A full-screen Bash 5.3 + Starship shell in the project root.

### Step 3: Navigate Between Neovim, `agy`, and `tmux` Windows
1. **Move between Neovim and `agy` (`Ctrl-l` / `Ctrl-h`)**:
   - From Neovim on the left, press `Ctrl-l` (no `Ctrl-a` prefix needed!) to jump into the `agy` pane on the right.
   - Press `Ctrl-h` to jump right back into Neovim.
2. **Switch to your full-screen shell window (`Ctrl-a Ctrl-a`)**:
   - Just like GNU `screen`, press `Ctrl-a Ctrl-a` to flip to Window 1 (`shell`), run a git or build command, and press `Ctrl-a Ctrl-a` to flip back to Window 0 (`code`).
3. **Toggle the Floating `agy` Popup (`Ctrl-a g`)**:
   - Even when you're in Window 1 (`shell`) or have Neovim zoomed full-screen (`Ctrl-a z`), press `Ctrl-a g` to summon an `85% x 85%` floating popup running a persistent `agy` session for the current repo.

### Step 4: Send Code Context from Neovim to `agy`
1. Inside Neovim, press `<Space>ff` to fuzzy-find and open a file with Telescope (or `<Space>fg` to live-grep across the repo).
2. **Send a whole file (`<Space>af`)**: In Normal mode, press `<Space>af`. Neovim sends `@path/to/file` directly into the `agy` prompt and focuses the `agy` pane.
3. **Send a specific line range (`<Space>as`)**: Highlight a block of lines with `V` + `j`/`k`, then press `<Space>as`. Neovim formats `@path/to/file#L10-L25`, types it directly into the `agy` prompt, and focuses `agy` so you can immediately type your question or instruction.
4. **Watch Auto-Reload in Action**: When `agy` edits the file on disk, your Neovim buffer reloads automatically and `gitsigns` highlights the changed lines in the left gutter (`]c` / `[c` to jump between hunks, `<Space>hp` to preview the diff).

---

## 3. Environment Verification Checklist

You can run these checks anytime to verify all components of **Gino's Super Dev Env**:

```bash
# 1. Verify CLI binaries
starship --version && fzf --version && rg --version && fd --version

# 2. Verify ~/.secrets permissions (must be 600)
stat -f '%Lp' ~/.secrets

# 3. Verify tmux 3.7+ configuration syntax
tmux -L test-dev-env -f ~/.tmux.conf new-session -d -s test_sess \; kill-server

# 4. Verify Neovim 0.12 & plugins load cleanly
nvim --headless -c 'lua assert(pcall(require, "telescope")); assert(pcall(require, "gitsigns")); assert(pcall(require, "oil")); print("OK")' -c 'qa'
```
