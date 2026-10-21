# Security Policy

## Secret Isolation Architecture

**Gino's Super Dev Env (`dev-env`)** is designed to strictly separate version-controlled configuration templates from private credentials:

1. **Untracked `~/.secrets` (`chmod 600`)**:
   - All API keys and personal access tokens (such as `HOMEBREW_GITHUB_API_TOKEN`) are stored exclusively in `~/.secrets` with `0600` (`-rw-------`) file permissions.
   - `.gitignore` explicitly blocks `.secrets`, `*.secrets`, `*.local`, `*.key`, and `*.pem` from ever being committed.
2. **Template Scrubbing**:
   - All files under `templates/` use generic placeholders (`{{GCP_PROJECT}}`, `{{GCP_LOCATION}}`, `{{WORKSPACE_DIR}}`) rather than hardcoded project identifiers or paths.

## Reporting a Vulnerability

If you discover a security issue in `install.sh`, `bin/ade`, or any configuration template (for example, insecure file permissions, command injection, or unintended credential exposure):

1. **Do not open a public issue** if the report involves a live credential or exploitable vulnerability.
2. Use **GitHub Private Vulnerability Reporting** (`Security` tab ➔ `Report a vulnerability`) on this repository so the maintainers can address the issue promptly.
