# Agent Rules for Gino's Super Dev Env (`dev-env`)

Whenever you add, modify, or remove any tool, script, dotfile template, alias, or keybinding in this repository, you MUST follow these rules:

## 1. Mandatory Documentation & Training Synchronization
Every change made to this repository MUST be reflected in both:
1. **`README.md`**:
   - Update the installation instructions, interactive prompt tables, installed file map, or keyboard shortcut reference tables to reflect the change.
2. **`TUTORIAL.md`**:
   - Update or add training material explaining what the new/updated program, feature, alias, or keybinding does, **why** it improves developer productivity, and how a user can practice it with a concrete example.
3. **`WALKTHROUGH.md` / `ARCHITECTURE.md` / `CHANGELOG.md`**:
   - Update `ARCHITECTURE.md` if low-level terminal/IPC mechanics change, `WALKTHROUGH.md` if the post-install tour changes, and `CHANGELOG.md` for notable additions.

## 2. Turnkey Cross-Platform Compatibility (macOS & Linux)
- All scripts (`install.sh`, `bin/ade`, `bin/dev-copy`) and templates (`templates/**`) must support both **macOS** (`arm64` & `x86_64`) and **Linux** (`x86_64` & `arm64`/`aarch64`, both with `sudo` package managers and rootless `~/.local` fallback).
- When modifying shell or `tmux` configurations, never hardcode macOS-only utilities (such as `pbcopy`, `open`, or `/usr/local/bin/bash`) without cross-platform Linux/SSH fallbacks (such as `~/bin/dev-copy` or `xdg-open`).

## 3. Secret Scrubbing & Apache 2.0 Open-Source Standards
- **Never** commit personal tokens (`ghp_...`), hardcoded personal home directory paths, private repository names, or private GCP project IDs into tracked files. Always use `$HOME` or `~` and template placeholders (`{{GCP_PROJECT}}`).
- Verify scrubbing across all tracked files before committing:
  ```bash
  ! git grep -iE "ghp_[A-Za-z0-9_]+|/(Users|home)/[A-Za-z0-9._-]+/"
  ```
- All new executable scripts must include the Apache 2.0 SPDX header:
  ```bash
  # Copyright 2026 The Gino's Super Dev Env Authors
  # SPDX-License-Identifier: Apache-2.0
  ```

## 4. Non-Blocking Git Remote Operations
- Never allow `git push`, `git pull`, or `git fetch` to hang waiting for an interactive SSH key passphrase in a background task.
- Always prefix SSH git network commands with `GIT_SSH_COMMAND="ssh -o BatchMode=yes"` so they fail immediately if the SSH agent is locked, or use non-interactive credentials.
