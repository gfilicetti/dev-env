# Gino's Super Dev Env — Complete Toolset Training & Tutorial (`TUTORIAL.md`)

Welcome to **Gino's Super Dev Env (`dev-env`)**!

If you have spent years (or decades) mastering classic **`vi`**, **`bash`**, and **GNU `screen`**, you already know the power of keeping your hands on the home row. This environment was engineered to **preserve 100% of your existing muscle memory** while upgrading every layer of your terminal stack with modern, blazingly fast Rust and Lua tools that work seamlessly together alongside the **Antigravity CLI (`agy`)** AI coding agent.

This tutorial takes you on a guided, hands-on tour through **every program installed by `./install.sh`**, explaining **what it is**, **why it makes you dramatically more productive**, and **concrete exercises** you can try right now.

---

## 📑 Table of Contents

1. [Overview of the New Toolset](#1-overview-of-the-new-toolset)
2. [Module 1: Modern Bash 5+ & GNU Readline `vi`-Mode](#module-1-modern-bash-5--gnu-readline-vi-mode)
3. [Module 2: Starship — The Two-Line Developer Prompt](#module-2-starship--the-two-line-developer-prompt)
4. [Module 3: `fzf` — Interactive Fuzzy Finder for History, Files & Directories](#module-3-fzf--interactive-fuzzy-finder-for-history-files--directories)
5. [Module 4: `ripgrep` (`rg`) & `fd` — Next-Generation Search & File Discovery](#module-4-ripgrep-rg--fd--next-generation-search--file-discovery)
6. [Module 5: `tmux` 3.x+ & `dev-copy` — Multiplexing for GNU `screen` Veterans](#module-5-tmux-3x--dev-copy--multiplexing-for-gnu-screen-veterans)
7. [Module 6: Neovim 0.12+ — Modern IDE Superpowers for Classic `vi` Users](#module-6-neovim-012--modern-ide-superpowers-for-classic-vi-users)
8. [Module 7: Antigravity CLI (`agy`) & `ade` — AI-Native Pair Programming](#module-7-antigravity-cli-agy--ade--ai-native-pair-programming)
9. [Module 8: Curated Aliases, Helper Functions & Universal Clipboard](#module-8-curated-aliases-helper-functions--universal-clipboard)

---

## 1. Overview of the New Toolset

When you run `./install.sh`, the following tools are installed and wired together:

| Program | Replaces / Upgrades | Why It Is a Game-Changer |
| :--- | :--- | :--- |
| **Bash 5.x + GNU Readline 8.x** | Classic macOS Bash 3.2 (2007) | Adds live `[I]`/`[N]` `vi`-mode badges, dynamic beam/block cursor shapes, 100,000-line deduplicated history, and case-insensitive tab completion. |
| **Starship (`starship`)** | Static `PS1` prompts | Rust-powered, sub-10ms 2-line prompt that shows Git branch/dirty/staged counts, language runtimes, slow-command timers (`>2s`), and exit codes without crowding your typing area. |
| **`fzf`** | `Ctrl-R` reverse-i-search & `find` | Instant interactive fuzzy search over 100k history commands (`Ctrl-R`), project files (`Ctrl-T`), and directories (`Alt-C`). |
| **`ripgrep` (`rg`)** | `grep -rn` | Multi-threaded Rust regex search that automatically respects `.gitignore` and skips binary files—10x to 50x faster than `grep`. |
| **`fd`** | `find . -name` | Intuitive, colorized, `.gitignore`-aware file finder written in Rust that powers both CLI searches and Neovim's file picker. |
| **`tmux` 3.x+** | GNU `screen` | Configured with your exact `Ctrl-a` `screen` keys, plus true side-by-side split panes, floating popups (`Ctrl-a g`), and zero-prefix `Ctrl-h/j/k/l` navigation with Neovim. |
| **Neovim 0.12+ (`nvim`)** | Classic `vi` / `vim` | Starts in `<25ms` with all your `.vimrc` settings intact, plus Telescope fuzzy finding, Gitsigns inline diffs, Oil directory editing, persistent undo, and live `agy` integration. |
| **`ade` (`tdev`) & `agy` Bridge** | Manual window arranging & copy-pasting | One command launches a 2-window IDE (`62% nvim` + `38% agy` + `shell`). Send `@file#L10-L25` straight from Neovim to `agy` and watch buffers auto-reload when `agy` edits code. |
| **`dev-copy` (`clip`)** | Platform-specific clipboards | Single clipboard engine that works identically on macOS (`pbcopy`), Linux Wayland (`wl-copy`), Linux X11 (`xclip`), and remote SSH servers via ANSI OSC 52 escape sequences. |

---

## Module 1: Modern Bash 5+ & GNU Readline `vi`-Mode

**Files involved**: `~/.bash_profile`, `~/.bashrc`, `~/.inputrc`

### Why It Makes You Productive
In classic `set -o vi` on older Bash (like macOS's default Bash 3.2 from 2007), the prompt looks identical whether you are in **Insert mode** or **Normal (Command) mode**. Every `vi` shell user has experienced typing a command only to realize they were in Normal mode and accidentally triggered five random edits.

With Modern Bash 5+ and `~/.inputrc`:
1. **Visual Mode Indicator + Cursor Shape Switching**:
   - In **Insert Mode**, your prompt displays a green **`[I]`** badge and a **thin vertical beam cursor (`|`)**.
   - Press **`<Esc>`** to enter **Normal Mode**, and the prompt immediately switches to a bold cyan **`[N]`** badge and a **solid block cursor (`█`)**.
2. **Prefix History Filtering (`Up`/`Down` or `k`/`j`)**:
   - If you type `git ` and press `Up` (or `<Esc>` then `k`), Readline only cycles through previous commands that **started with `git `**, rather than every command you ran recently.
3. **100,000-Line Deduplicated History**:
   - `HISTFILESIZE=100000` with `HISTCONTROL=ignoreboth:erasedups` means your shell remembers years of complex commands without cluttering your history with thousands of duplicate `ls` or `git status` entries.
4. **Edit Command in Full Neovim (`<Esc> v`)**:
   - When composing a long `curl`, `awk`, or `for`-loop command on the command line, press `<Esc>` then `v`. Bash opens the current command line inside **Neovim**, where you can edit it with full syntax highlighting and multi-line motions; when you `:wq`, Bash executes it.

### 🧪 Try It Now (Hands-On Exercise)
1. At your Bash prompt, notice the green `[I]` and thin beam cursor (`|`).
2. Type `echo "hello world"` (don't press Enter yet).
3. Press **`<Esc>`** — watch `[I]` become `[N]` and the cursor become a solid block (`█`).
4. Press **`B`** to jump back a word, **`cw`** to change `"world"` to `"dev-env"`, and **`<Esc>`** again.
5. Press **`v`** while in `[N]` mode — Neovim opens with your command line! Type `:q!` to cancel or `:wq` to run it.

---

## Module 2: Starship — The Two-Line Developer Prompt

**Files involved**: `~/.config/starship.toml`, ** SauceCodePro Nerd Font**

### Why It Makes You Productive
Why do experienced terminal developers use a **two-line prompt** instead of a traditional one-line `user@host:/long/path/to/repo (branch)>` prompt?
- When your screen is split side-by-side (`62%` Neovim on the left, `38%` terminal or `agy` on the right), a single-line prompt with path + Git branch eats up 70% of the column width, causing every command you type to wrap awkwardly across lines.
- A **two-line prompt** puts all rich situational awareness on **Line 1** and gives **Line 2** 100% of the horizontal width starting at column 1.

Here is how to read **Line 1** of your Starship prompt:

```text
dev-env/templates on  main [!2 +1 ?1 ⇡1] via 🐍 v3.12.4 (venv) took 4s
[I] ❯ _
```

| Segment | Example | Meaning & Why It Helps |
| :--- | :--- | :--- |
| **SSH User@Host** | `user@remote-host in ` | **Hidden on your local machine** (zero noise!), but automatically lights up in bold yellow the moment you `ssh` into a remote server so you never run a destructive command on the wrong box. |
| **Smart Directory** | `dev-env/templates` | Automatically truncates parent folders (`~/Repositories/...`) to the **Git repository root** so you always know which repo and subfolder you are in. |
| **Git Branch** | `on  main` | Shows your current branch or detached commit hash. |
| **Git Status** | `[!2 +1 ?1 ⇡1⇣2]` | Instant `git status` without typing a key: `!2` = 2 modified unstaged files, `+1` = 1 staged file, `?1` = 1 untracked file, `⇡1` = 1 commit ahead of `origin`, `⇣2` = 2 commits behind `origin`, `$1` = 1 stashed change. |
| **Language / Runtime**| `via 🐍 v3.12 (venv)` | **Context-aware**: Only appears when your current directory contains a project file (`pyproject.toml`, `package.json`, `go.mod`, `Cargo.toml`, `pom.xml`, etc.). Shows active Python virtualenv, Node, Go, Rust, or Java version. |
| **Command Timer** | `took 4s` | **Silent for fast commands**, but if a build or test takes longer than `2 seconds`, tells you exactly how long it ran. |
| **Exit Code Badge** | `✘ 1` (on Line 2) | If the previous command failed (non-zero exit code), displays a bold red `✘ <code >` right before `❯` so silent failures never go unnoticed. |

### 🧪 Try It Now (Hands-On Exercise)
1. Run `sleep 3` — notice `took 3s` appear in yellow on the right of Line 1.
2. Run `false` — notice `✘ 1` appear in red on Line 2 next to `[I]`.
3. Inside any Git repo, run `touch test_untracked.tmp` — notice `[?1]` appear immediately in your prompt. Run `rm test_untracked.tmp` and watch it disappear.

---

## Module 3: `fzf` — Interactive Fuzzy Finder for History, Files & Directories

**Binary**: `fzf` (configured in `~/.bashrc`)

### Why It Makes You Productive
`fzf` is an interactive Unix filter that replaces slow, error-prone workflows like `history | grep ...`, `find . -name ...`, and repetitive `cd ../../..` navigation. It uses approximate ("fuzzy") matching: you only need to type a few non-contiguous characters from any part of a command or filename to narrow 100,000 items down to the exact one you want in milliseconds.

### The Three Built-In `fzf` Keybindings in Your Shell

#### 1. `Ctrl-R` (or `<Esc>` then `/` in `vi` mode) — Fuzzy Command History
- Press **`Ctrl-R`** (or `<Esc>` then `/`).
- An interactive list of your 100,000-line deduplicated command history opens.
- Type fragments of what you remember—for example, `git push main` or `docker 8080`.
- Use `Up`/`Down` (or `Ctrl-k`/`Ctrl-j` or `Ctrl-p`/`Ctrl-n`) to select a command:
  - Press **`Enter`** to paste the command onto your prompt so you can review or edit it before running.

#### 2. `Ctrl-T` — Fuzzy File Picker (Insert Paths into Current Command)
- Suppose you want to open or `cat` or `git add` a deeply nested file, like `templates/antigravity/settings.json.tmpl`.
- Type `nvim ` (with a trailing space) and press **`Ctrl-T`**.
- Type `settmpl` or `antig` — `fzf` highlights `templates/antigravity/settings.json.tmpl`.
- Press **`Enter`**, and the full path is inserted right after `nvim `!
- **Pro Tip**: Inside `Ctrl-T`, press **`Tab`** on multiple files to select several at once, then press `Enter` to insert all of them onto your command line.

#### 3. `Alt-C` (or `<Esc>` then `c`) — Fuzzy Directory Jump
- Press **`Esc`** followed quickly by **`c`** (or `Alt-C`).
- `fzf` lists all subdirectories under your current working directory.
- Type a few letters of the target directory and press **`Enter`** to `cd` directly into it.

### `fzf` Search Syntax Cheatsheet
Inside any `fzf` prompt (`Ctrl-R`, `Ctrl-T`, `Alt-C`, or pipe):
- `foo bar` — Matches items containing both `foo` and `bar` in any order.
- `^git` — Prefix match (must start with `git`).
- `.lua$` — Suffix match (must end with `.lua`).
- `'exact` — Exact substring match (disable fuzzy matching for that word).
- `!bak` — Inverse match (exclude any item containing `bak`).

### Piping Any Command into `fzf`
Because `fzf` is a standard Unix filter (reads `stdin`, writes your selection to `stdout`), you can combine it with anything:
```bash
# Interactively pick a git branch to checkout:
git checkout $(git branch --format='%(refname:short)' | fzf)

# Interactively pick a running process to inspect:
ps aux | fzf
```

---

## Module 4: `ripgrep` (`rg`) & `fd` — Next-Generation Search & File Discovery

**Binaries**: `rg` (`ripgrep`), `fd`

### Why They Make You Productive
Classic `grep -rn` and `find . -name` were designed before Git repositories, `node_modules/`, `.venv/`, and `.git/` folders existed. Running `grep -rn "foo" .` in a modern repository wastes seconds scanning gigabytes of `.git/` objects, build artifacts, and minified dependencies.

**`ripgrep` (`rg`)** and **`fd`** solve this automatically:
1. **Automatic `.gitignore` Respect**: By default, both `rg` and `fd` skip `.git/`, `node_modules/`, build directories, and anything listed in `.gitignore`.
2. **Smart Case**: Searching lowercase (`rg starship`) is case-insensitive; adding an uppercase letter (`rg Starship`) automatically switches to case-sensitive.
3. **Blazing Parallel Speed**: Written in Rust using SIMD optimizations and parallel directory traversal—they also power Neovim's `<Space>ff` and `<Space>fg` Telescope pickers under the hood.

### Essential `ripgrep` (`rg`) Commands
```bash
# 1. Fast recursive search in current repo (respects .gitignore automatically)
rg "MULTIPLEXER_PROMPT"

# 2. Search only inside specific file types (e.g. sh, lua, py, go, js, md)
rg -t lua "keymap"
rg -t sh "dev-copy"

# 3. Show 3 lines of context before and after each match (-C 3)
rg -C 3 "copy-mode-vi"

# 4. Search including hidden (.dotfiles) and gitignored files (-u / -uu)
rg -u "HISTFILESIZE"

# 5. Match literal string (disable regex special characters like . * [ ])
rg -F "set -g prefix C-a"

# 6. List only filenames that contain a match (-l)
rg -l "Apache-2.0"
```

### Essential `fd` Commands (Replaces `find`)
```bash
# 1. Find files matching a pattern anywhere in the current directory tree
fd tmpl

# 2. Find files by extension (-e)
fd -e lua
fd -e md

# 3. Include hidden dotfiles (-H)
fd -H bash

# 4. Execute a command on every matching file in parallel (-x)
fd -e sh -x shellcheck {}
```

---

## Module 5: `tmux` 3.x+ & `dev-copy` — Multiplexing for GNU `screen` Veterans

**Files involved**: `~/.tmux.conf`, `~/bin/dev-copy`

### Why It Makes You Productive
If you have used GNU `screen` for years, `tmux` gives you everything you love about `screen` (persistent background sessions, multiple windows, `Ctrl-a` prefix, bottom status bar) while adding three game-changing capabilities:
1. **First-Class Side-by-Side Split Panes** that remember your working directory and resize smoothly.
2. **Seamless `Ctrl-h / j / k / l` Navigation** that crosses between Neovim splits and `tmux` panes **without pressing `Ctrl-a`**.
3. **Floating Popup Windows (`Ctrl-a g`)** that overlay an interactive session on top of your workspace and disappear with a single keystroke without disturbing your window layout.

### 1. Your GNU `screen` Muscle Memory Works Unchanged
Every classic `screen` key chord is preserved in `~/.tmux.conf`:
- **`Ctrl-a c`**: Create a new window (automatically opens in the current pane's directory!).
- **`Ctrl-a Ctrl-a`** (or `Ctrl-a l`): Flip back and forth between the current and last active window.
- **`Ctrl-a 0` .. `9`** (or `Ctrl-a n` / `Ctrl-a p`): Jump to window by number, or next/previous window.
- **`Ctrl-a "`** (or `Ctrl-a w`): Open an interactive visual tree of all sessions, windows, and panes with live preview.
- **`Ctrl-a A`**: Rename the current window.
- **`Ctrl-a K`**: Kill the current pane/window (with a `(y/n)` safety prompt).
- **`Ctrl-a d`**: Detach from the session (leave everything running in the background).
- **`Ctrl-a a`**: Send a literal `Ctrl-a` to the underlying program (e.g., to increment a number in `nvim` or jump to the start of a line).

### 2. Mastering Split Panes & Zoom
Unlike `screen`, splitting a window in `tmux` is effortless and preserves your current directory:
- **`Ctrl-a |`** (or **`Ctrl-a h`**): Split the current pane **horizontally** (left / right).
- **`Ctrl-a -`** (or **`Ctrl-a v`**): Split the current pane **vertically** (top / bottom).
- **`Ctrl-h` / `Ctrl-j` / `Ctrl-k` / `Ctrl-l`**: Move focus Left / Down / Up / Right across both Neovim splits and `tmux` panes (**no `Ctrl-a` prefix needed!**).
- **`Ctrl-a z`**: **Zoom / Unzoom** the current pane. Need to focus exclusively on Neovim or read a wide log table in your shell? Press `Ctrl-a z` to make the active pane full-screen; press `Ctrl-a z` again to restore your split layout.
- **`Ctrl-a H / J / K / L`**: Resize the active pane by 5 cells in any direction (repeatable without pressing `Ctrl-a` again).

### 3. Keyboard-Only `vi` Copy Mode & Universal Clipboard (`dev-copy`)
Because `mouse off` is set so your terminal's native mouse selection works without holding `Option`/`Shift`, `tmux` also gives you lightning-fast keyboard copy-mode:
1. Press **`Ctrl-a Esc`** (or `Ctrl-a [`) to freeze the pane scrollback (100,000 lines!) and enter `vi` copy mode.
2. Navigate using standard `vi` keys: `k`/`j`, `Ctrl-u`/`Ctrl-d`, `g`/`G`, or `/search_term`.
3. Press **`v`** to start character selection (or **`V`** for whole-line selection).
4. Move to the end of what you want to copy and press **`y`** (or **`Enter`**).
5. Your selection is piped through **`~/bin/dev-copy`**, which automatically copies it to:
   - **macOS Clipboard** (`pbcopy`)
   - **Linux Wayland / X11 Clipboard** (`wl-copy` / `xclip` / `xsel`)
   - **Your Local Laptop Clipboard over SSH** via ANSI **OSC 52** escape sequences!

---

## Module 6: Neovim 0.12+ — Modern IDE Superpowers for Classic `vi` Users

**Files involved**: `~/.config/nvim/init.lua`

### Why It Makes You Productive
Many "Neovim distributions" turn Vim into a bloated GUI with tab bars, mouse sidebars, and unfamiliar keybindings that break classic `vi` workflows.

Your `~/.config/nvim/init.lua` takes the opposite approach:
- It is a **single, clean, readable file** that keeps 100% of your `.vimrc` settings (`4`-space indentation, `mouse=""` disabled so terminal copy/paste is never hijacked, `writebackup`, last-cursor position restore, and `:DiffOrig`).
- It adds **four surgical plugins** (`telescope.nvim`, `gitsigns.nvim`, `oil.nvim`, and `nvim-treesitter`) bound under **`<Space>`** (your Leader key) so none of your native `vi` keys are overwritten.

---

### Superpower 1: Built-In Neovim 0.12 Upgrades Over Classic `vi`
Even before touching a plugin, Neovim 0.12 gives you:
1. **Persistent Undo (`undofile`)**:
   - Close a file, quit Neovim, reboot your machine, reopen the file tomorrow, and press **`u`** — Neovim still remembers your undo history for that file (stored safely in `~/.local/state/nvim/undo`).
2. **Live Substitution Preview (`inccommand = "split"`)**:
   - Type `:%s/old_word/new_word/g` (before pressing Enter!). As you type `new_word`, Neovim opens a live preview split showing every line that will change and highlighting the exact replacement in real time.
3. **Instant Search Highlight Clear (`<Esc>`)**:
   - After searching with `/pattern`, just press **`<Esc>`** in Normal mode to clear the yellow search highlighting.
4. **Unified System Clipboard (`clipboard = "unnamedplus"`)**:
   - Pressing `yy` or `yiw` in Neovim automatically copies to your system clipboard, and `p` pastes from it.

---

### Superpower 2: Telescope (`<Space>ff`, `<Space>fg`, `<Space>fb`, `<Space>fr`)
Stop typing `:e path/to/some/deep/file.py`. Telescope gives you an instant fuzzy popup with a syntax-highlighted preview window:

| Key Chord (Normal Mode) | Action | When to Use It |
| :--- | :--- | :--- |
| **`<Space>ff`** | **Find Files** | Fuzzy-find any file in the repository by name (powered by `fd`). |
| **`<Space>fg`** | **Live Grep** | Type any string or regex and watch `ripgrep` search the entire codebase in real time with file/line preview. |
| **`<Space>fb`** | **Find Buffers** | Fuzzy-switch between all currently open files in Neovim (replaces `:ls` + `:b N`). |
| **`<Space>fr`** | **Recent Files** | Jump to any file you recently opened across sessions. |
| **`<Space>fh`** | **Help Tags** | Fuzzy-search Neovim's built-in documentation. |

- **Inside any Telescope popup**:
  - Type to filter; use **`Ctrl-j`** / **`Ctrl-k`** (or `Down`/`Up`) to move through results.
  - Press **`Enter`** to open the file, **`Ctrl-v`** to open in a vertical split, or **`Ctrl-x`** to open in a horizontal split.
  - Press **`<Esc>`** to close the popup.

---

### Superpower 3: `oil.nvim` (`-`) — Edit Your Filesystem Like a `vi` Buffer
Instead of a clumsy tree sidebar on the left of your screen, `oil.nvim` lets you manage files and directories using standard `vi` text-editing commands:
1. From any open file in Neovim, press **`-`** (minus) in Normal mode.
2. Neovim opens the **parent directory** as a normal text buffer where every line is a file or folder!
3. Navigate with `j` / `k`, press **`Enter`** on a directory or file to open it, or press **`-`** again to go up another parent directory.
4. **Want to rename a file?** Move your cursor to the filename, use `cw` or `ciw` to change the name just like editing text, and type **`:w`**.
5. **Want to create a new file or folder?** Press `o` to open a new line, type `newfile.py` (or `newfolder/` with a trailing slash), and type **`:w`**.
6. **Want to delete a file?** Press `dd` on its line and type **`:w`** (Oil will show a confirmation dialog before touching disk).

---

### Superpower 4: `gitsigns.nvim` — Live Git Gutter & Hunk Operations
Whenever you (or `agy`) modify a file tracked by Git, `gitsigns` shows `+` (added), `~` (changed), or `_` (deleted) indicators in the left sign column:

| Key Chord (Normal Mode) | Action | Why It Is Useful |
| :--- | :--- | :--- |
| **`]c`** | **Next Git Hunk** | Jump directly to the next modified block in the current file. |
| **`[c`** | **Previous Git Hunk** | Jump directly to the previous modified block in the current file. |
| **`<Space>hp`** | **Preview Hunk Diff** | Pops up an inline floating diff showing what the lines looked like before the change. |
| **`<Space>hr`** | **Reset (Revert) Hunk** | Instantly revert the single hunk under your cursor back to `HEAD` without affecting the rest of the file! |
| **`<Space>hb`** | **Blame Current Line** | Shows a floating popup with the full Git commit message and author who last changed this line. |

---

## Module 7: Antigravity CLI (`agy`) & `ade` — AI-Native Pair Programming

**Files involved**: `~/bin/ade`, `~/.tmux.conf`, `~/.config/nvim/init.lua`, `~/.gemini/antigravity-cli/settings.json`

### Why It Makes You Productive
When working with an AI coding assistant in a browser or separate window, you waste time copying file paths, pasting code blocks back and forth, and manually reloading files after the agent edits them.

**Gino's Super Dev Env** bridges **Neovim 0.12**, **`tmux`**, and **Antigravity CLI (`agy`)** into a single cohesive loop:

### 1. Launch Your Workspace in One Command (`ade` or `tdev`)
From any repository directory, run:
```bash
ade            # or: tdev
```
This creates (or reattaches to) a persistent per-repository `tmux` session (`dev-<repo>`) with:
- **Window 0 (`code`)**:
  - **Left Pane (62%)**: Neovim 0.12 (`nvim`)
  - **Right Pane (38%)**: Antigravity CLI (`agy`)
- **Window 1 (`shell`)**:
  - Full-screen Bash 5+ shell for running tests, builds, or `git` commands.

*(Prefer full-screen Neovim with `agy` hidden until you need it? Run `ade -p` for Popup Mode!)*

### 2. Summon `agy` From Anywhere (`Ctrl-a g` & `Ctrl-a G`)
- **`Ctrl-a g` (Floating `agy` Popup)**:
  - Whether you are in Window 1 (`shell`) debugging a test failure or have Neovim zoomed full-screen, press **`Ctrl-a g`**.
  - An `85% x 85%` floating popup appears over your terminal, attached to a persistent `agy-<repo>` session.
  - Ask `agy` a question or give it a task, then press **`Ctrl-a d`** (or close the popup) to hide it while it works in the background. Press **`Ctrl-a g`** again anytime to check on it!
- **`Ctrl-a G` (Right-Hand `agy` Split)**:
  - Opens a `38%` right-hand side split running `agy` in the current pane's working directory.

### 3. Send Code Context from Neovim Straight into `agy` (`<Space>af` & `<Space>as`)
Instead of typing filenames or line numbers into `agy` by hand:
1. **Send the Current File (`<Space>af`)**:
   - While viewing any file in Neovim (Normal mode), press **`<Space>af`**.
   - Neovim automatically finds the `agy` pane in your `tmux` window, types `@path/to/current/file ` into the `agy` prompt, and **moves your cursor focus into the `agy` pane** so you can immediately type your instruction (e.g., *"refactor the error handling in this file"*).
2. **Send a Visual Line Selection (`<Space>as`)**:
   - In Neovim, highlight a function or block of lines using Visual mode (`v` or `V` + `j`/`k`).
   - Press **`<Space>as`**.
   - Neovim computes the exact line range, injects `@path/to/file#L42-L78 ` into the `agy` prompt, and focuses the `agy` pane!

### 4. Automatic Buffer Reload & Hunk Review When `agy` Edits Files
When `agy` modifies files on disk:
1. **Zero `:e!` Needed**: Neovim's `FocusGained` and `CursorHold` hooks automatically detect the disk change within `250ms`, reload the buffer, and display a subtle notification: `Buffer auto-reloaded (updated on disk by agy)`.
2. **Review `agy`'s Changes Like a Pro**:
   - Press **`Ctrl-h`** from the `agy` pane to jump back into Neovim.
   - Press **`]c`** and **`[c`** to hop through every hunk `agy` modified.
   - Press **`<Space>hp`** on any hunk to see the inline before/after diff.
   - Don't like one specific change `agy` made? Press **`<Space>hr`** to revert just that hunk while keeping the rest!

---

## Module 8: Curated Aliases, Helper Functions & Universal Clipboard

**Files involved**: `~/.alias`, `~/.alias_kubectl`, `~/bin/dev-copy`

### 1. Universal Clipboard Command (`dev-copy` / `clip`)
Whether you are on a local Mac, a Linux desktop (Wayland or X11), or SSH'd into a headless Linux server inside `tmux`, you can pipe any command's output into **`clip`** (or `dev-copy`) to put it on your local system clipboard:
```bash
# Copy your public SSH key to clipboard (works on Mac, Linux, and over SSH!):
cat ~/.ssh/id_ed25519.pub | clip

# Copy the latest git commit hash to clipboard:
git rev-parse --short HEAD | clip
```

### 2. Daily Productivity Aliases (`~/.alias`)

| Alias / Function | Expands To / Action | Why It Is Useful |
| :--- | :--- | :--- |
| **`tdev`** | `ade` | Launches the `tmux` + `nvim` + `agy` IDE workspace for the current repo. |
| **`clip`** | `dev-copy` | Copies `stdin` or file contents to your system clipboard on Mac, Linux, or over SSH. |
| **`ducks`** | `du -cks * \| sort -rn \| head -11` | Shows the top 10 largest files/folders in the current directory (in KB). |
| **`mkcd <dir>`** | `mkdir -p <dir> && cd <dir>` | Creates a nested directory and immediately `cd`s into it. |
| **`whatsmyip`** | `curl -s api.ipify.org \| jq -r .ip` | Prints your current public external IPv4/IPv6 address. |
| **`update`** | OS-aware system & package updater | Runs `softwareupdate` + `brew upgrade` on macOS, or `apt`/`dnf`/`pacman`/`apk` upgrade on Linux. |
| **`pf [dir]`** | Open in graphical file manager | Opens directory in Path Finder / Finder on macOS, or `xdg-open` on Linux. |
| **`edal` / `srcal`** | Edit / reload `~/.alias` | Quickly add a new alias in Neovim and reload it in your current shell. |
| **`edsh` / `srcsh`** | Edit / reload `~/.bashrc` | Quickly edit `~/.bashrc` in Neovim and reload it. |
| **`ednv`** | `nvim ~/.config/nvim/init.lua` | Open your Neovim configuration directly. |
| **`edtm`** | `nvim ~/.tmux.conf` | Open your `tmux` configuration directly. |
| **`g` / `gs` / `gl` / `gp` / `gf`** | `git` / `status` / `pull` / `push` / `fetch --prune` | Fast 2-letter Git muscle-memory shortcuts. |
| **`k` / `kgpo` / `klo` / `kex`** | `kubectl` shortcuts (`~/.alias_kubectl`) | Full suite of standard Kubernetes CLI shortcuts (`kgpo` = get pods, `klo` = logs -f, etc.). |

---

## 🎓 Quick 5-Minute Practice Drill for New Users

Run through this 5-minute drill once to lock the new workflows into your muscle memory:

1. **Shell & `fzf`**:
   - Open your terminal and press **`<Esc>`** then **`i`** to see the `[N]` (block cursor) and `[I]` (beam cursor) switch.
   - Press **`Ctrl-R`**, type `install`, and press **`<Esc>`** to close the fuzzy history picker.
2. **Launch Workspace (`ade`)**:
   - `cd ~/Repositories/dev-env && ade`
3. **Navigate Splits & Windows**:
   - Press **`Ctrl-l`** to jump from Neovim (left) to `agy` (right).
   - Press **`Ctrl-h`** to jump back to Neovim.
   - Press **`Ctrl-a Ctrl-a`** to flip to Window 1 (`shell`), then **`Ctrl-a Ctrl-a`** to flip back to Window 0 (`code`).
4. **Neovim Telescope & Oil**:
   - Inside Neovim, press **`<Space>ff`**, type `starship`, and press **`Enter`** to open `templates/starship/starship.toml`.
   - Press **`<Space>fg`**, type `truncation_length`, and press **`Enter`** to jump straight to that setting.
   - Press **`-`** to view the `templates/starship/` directory in `oil.nvim`, then press **`Enter`** on `starship.toml` to return to the file.
5. **Send Context to `agy`**:
   - Move your cursor to any section of `starship.toml`, press **`V`** + **`jjj`** to highlight 4 lines, and press **`<Space>as`**.
   - Notice `@templates/starship/starship.toml#L...` is now waiting in your `agy` prompt on the right!
