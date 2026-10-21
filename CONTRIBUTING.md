# Contributing to Gino's Super Dev Env

Thank you for your interest in contributing to **Gino's Super Dev Env (`dev-env`)**!

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md) and agree that your contributions will be licensed under the [Apache License, Version 2.0](LICENSE).

---

## 🛠️ Development & Testing Workflow

### 1. Secret & Personal Data Scrubbing (Critical)
Because this repository contains shell, editor, and agent templates, **never commit personal credentials, usernames, or private project names**.
Before submitting a pull request, verify that:
- All personal paths use `$HOME` or `~` instead of hardcoded user home directories.
- All tokens/API keys belong exclusively in untracked `~/.secrets` (documented in `templates/bash/secrets.example`).
- User-configurable settings use template placeholders (`{{GCP_PROJECT}}`, `{{GCP_LOCATION}}`, `{{WORKSPACE_DIR}}`, `{{MULTIPLEXER_PROMPT}}`) rendered by `install.sh`.

### 2. Validate Your Changes Locally
Run the following verification checks before opening a Pull Request:

```bash
# 1. Validate bash script syntax
bash -n install.sh
bash -n bin/ade

# 2. Preview template rendering and backup logic without modifying your home directory
./install.sh --defaults --dry-run

# 3. Validate tmux 3.7+ configuration syntax
tmux -L test-dev-env -f templates/tmux/tmux.conf new-session -d -s test_sess \; kill-server
```

---

## 📋 Pull Request Guidelines

1. Fork the repository and create a topic branch from `main`.
2. **Documentation & Training Sync (Required)**: Every feature, tool, keybinding, or installer change **must** be reflected in:
   - [`README.md`](README.md) — Update installation instructions, file maps, and keyboard reference tables.
   - [`TUTORIAL.md`](TUTORIAL.md) — Add training material explaining what the new feature/tool does, why it improves productivity, and how to use it.
   - [`WALKTHROUGH.md`](WALKTHROUGH.md) — Update the quick post-install tour if applicable.
3. If your change alters how components interact (`bash`, `starship`, `tmux`, `nvim`, or `agy`), update [`ARCHITECTURE.md`](ARCHITECTURE.md).
4. Add an entry under `[Unreleased]` in [`CHANGELOG.md`](CHANGELOG.md).
5. Ensure new scripts include the standard Apache 2.0 `SPDX-License-Identifier: Apache-2.0` header.
