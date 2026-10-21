# Changelog

All notable changes to **Gino's Super Dev Env (`dev-env`)** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-20

### Added
- **Bash 5.3 + Starship + Readline + `fzf` Stack**:
  - Two-line developer prompt (`templates/starship/starship.toml`) with smart Git-root truncation, Git status counters, runtime/virtualenv detection, slow-command duration timer (`>2s`), and SSH-only `user@host`.
  - GNU Readline `vi`-mode configuration (`templates/bash/inputrc`) with live `[I]`/`[N]` prompt badges and DECSCUSR beam/block cursor switching.
  - 100,000-line deduplicated Bash history paired with `fzf` (`Ctrl-R` history search, `Ctrl-T` file finder).
  - Secret isolation via `chmod 600 ~/.secrets` (`templates/bash/secrets.example`).
- **`tmux` 3.7+ Configuration (`templates/tmux/tmux.conf`)**:
  - Full GNU `screen` muscle-memory parity (`Ctrl-a` prefix, `Ctrl-a Ctrl-a` last window, `K` kill pane, `Escape` `vi` copy-mode to `pbcopy`, bottom hardstatus-style status bar with cross-platform `loadavg`).
  - Zero-prefix `Ctrl-h/j/k/l` navigation between Neovim splits and `tmux` panes.
  - `Ctrl-a g` floating Antigravity CLI (`agy`) popup and `Ctrl-a G` right-hand `agy` sidebar split.
- **Neovim 0.12 Configuration (`templates/nvim/init.lua`)**:
  - Preserves classic `.vimrc` preferences (`shiftwidth=4`, `tabstop=4`, `mouse=""`, `writebackup`, last-cursor restore, `:DiffOrig`).
  - Bootstraps `lazy.nvim` with `telescope.nvim`, `gitsigns.nvim`, `oil.nvim`, and `nvim-web-devicons`.
  - Real-time buffer auto-reload (`FocusGained` / `CursorHold` / `checktime`) when `agy` edits files on disk.
  - `<Space>af` and `<Space>as` keymaps to inject `@file` and `@file#Lstart-Lend` context directly into the active `agy` pane.
- **Workspace Launcher & Interactive Installer**:
  - `bin/ade` (`tdev`) launcher script creating a 2-window `tmux` session (`code`: 62% `nvim` + 38% `agy`; `shell`: Bash 5.3).
  - `install.sh` interactive setup wizard with prebuilt binary downloads, timestamped backups (`~/.dev-env-backup`), `--dry-run`, `--defaults`, and `--uninstall`.
- **Documentation & Open-Source Governance**:
  - Added `README.md`, `WALKTHROUGH.md`, `ARCHITECTURE.md`, `LICENSE` (Apache 2.0), `NOTICE`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `CHANGELOG.md`.
