-- =============================================================================
-- ~/.config/nvim/init.lua — Gino's Super Dev Env (Neovim 0.12+)
-- =============================================================================
-- Designed for longtime Vi/Vim users adopting modern Neovim + Antigravity CLI (agy).
--
-- Features:
--   1. Classic .vimrc muscle memory preserved (4-space tabs, mouse="", writebackup,
--      jump to last cursor position, Q formatting, :DiffOrig).
--   2. Modern Neovim 0.12 upgrades (persistent undo, live :%s split preview,
--      yank highlight, native diagnostic & LSP keymaps).
--   3. Curated minimal plugins via lazy.nvim (Treesitter, Telescope fuzzy finder,
--      Gitsigns live gutter diffs, Oil buffer-style directory editing).
--   4. Antigravity CLI (agy) Live Bridge:
--      - Automatic buffer reload whenever agy modifies files on disk
--      - <Space>af : Send current @file path to the active agy tmux pane
--      - <Space>as : Send visual selection @file#Lstart-Lend to the agy tmux pane
-- =============================================================================

-- Leader key: <Space>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -----------------------------------------------------------------------------
-- 1. Core Options (Preserved from classic ~/.vimrc + Neovim 0.12 upgrades)
-- -----------------------------------------------------------------------------
local opt = vim.opt

-- Indentation & Tabs (from ~/.vimrc)
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- UI & Terminal (from ~/.vimrc)
opt.number = true
opt.ruler = true
opt.showcmd = true
opt.title = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 6
opt.updatetime = 250

-- Keep mouse disabled so native iTerm2 selection & copy/paste always works
opt.mouse = ""

-- Backups, Swap & Persistent Undo (upgraded from ~/.vimrc)
opt.writebackup = true
opt.directory = "/tmp//"
opt.undofile = true

-- Search & Live Substitution Preview
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"      -- Live split preview during :%s/foo/bar/g

-- Splits open naturally to the right and below
opt.splitright = true
opt.splitbelow = true

-- Auto-reload files modified externally by Antigravity CLI (agy)
opt.autoread = true

-- Built-in matchit is loaded by default in Neovim, plus colorscheme fallback
vim.cmd.colorscheme("habamax")

-- -----------------------------------------------------------------------------
-- 2. Classic Keymaps & Autocommands (from ~/.vimrc)
-- -----------------------------------------------------------------------------
local keymap = vim.keymap.set

-- Don't use Ex mode; use Q for formatting (from ~/.vimrc)
keymap("n", "Q", "gq", { desc = "Format with gq" })

-- Break undo sequence before <C-u> in insert mode (from ~/.vimrc)
keymap("i", "<C-u>", "<C-g>u<C-u>", { desc = "Delete to start of line with undo break" })

-- Clear search highlighting with <Esc> in normal mode
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Seamless Ctrl-h/j/k/l between Neovim splits and tmux panes
local function tmux_or_nvim_nav(dir, tmux_flag)
    return function()
        local cur_win = vim.api.nvim_get_current_win()
        vim.cmd("wincmd " .. dir)
        if vim.api.nvim_get_current_win() == cur_win and vim.env.TMUX then
            vim.fn.system({ "tmux", "select-pane", tmux_flag })
        end
    end
end
keymap("n", "<C-h>", tmux_or_nvim_nav("h", "-L"), { silent = true, desc = "Move left (split or tmux pane)" })
keymap("n", "<C-j>", tmux_or_nvim_nav("j", "-D"), { silent = true, desc = "Move down (split or tmux pane)" })
keymap("n", "<C-k>", tmux_or_nvim_nav("k", "-U"), { silent = true, desc = "Move up (split or tmux pane)" })
keymap("n", "<C-l>", tmux_or_nvim_nav("l", "-R"), { silent = true, desc = "Move right (split or tmux pane)" })

-- Jump to the last known cursor position when opening a file (from ~/.vimrc)
local vimrc_group = vim.api.nvim_create_augroup("GinoVimrcEx", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vimrc_group,
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 1 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Brief visual highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vimrc_group,
    callback = function()
        vim.highlight.on_yank({ timeout = 150 })
    end,
})

-- :DiffOrig command (from ~/.vimrc) to view unsaved changes vs disk
if vim.fn.exists(":DiffOrig") == 0 then
    vim.api.nvim_create_user_command("DiffOrig", function()
        vim.cmd("vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis")
    end, { desc = "Diff current buffer against file on disk" })
end

-- -----------------------------------------------------------------------------
-- 3. Antigravity CLI (agy) Auto-Reload & Context Bridge
-- -----------------------------------------------------------------------------
local agy_group = vim.api.nvim_create_augroup("AntigravityBridge", { clear = true })

-- Automatically check disk changes when switching panes, focusing window, or idling
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = agy_group,
    callback = function()
        if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
            vim.cmd("silent! checktime")
        end
    end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
    group = agy_group,
    callback = function()
        vim.notify("Buffer auto-reloaded (updated on disk by agy)", vim.log.levels.INFO)
    end,
})

-- Helper: Find an active tmux pane running agy (or non-current pane) and send text
local function send_to_agy_pane(text)
    if not vim.env.TMUX then
        vim.fn.setreg("+", text)
        vim.notify("Copied to clipboard (not in tmux): " .. text, vim.log.levels.INFO)
        return
    end

    -- Look for a pane running 'agy' in the current tmux window, or fall back to next pane
    local panes_out = vim.fn.systemlist({
        "tmux", "list-panes", "-F", "#{pane_id} #{pane_active} #{pane_current_command}"
    })
    local target_pane = nil
    local fallback_pane = nil
    for _, line in ipairs(panes_out) do
        local id, active, cmd = line:match("^(%%%d+) (%d) (.+)$")
        if id and active == "0" then
            fallback_pane = fallback_pane or id
            if cmd:lower():find("agy") then
                target_pane = id
                break
            end
        end
    end
    target_pane = target_pane or fallback_pane

    if not target_pane then
        vim.fn.setreg("+", text)
        vim.notify("No secondary tmux pane found; copied to clipboard: " .. text, vim.log.levels.WARN)
        return
    end

    vim.fn.system({ "tmux", "send-keys", "-t", target_pane, "-l", text .. " " })
    vim.fn.system({ "tmux", "select-pane", "-t", target_pane })
    vim.notify("Sent to agy: " .. text, vim.log.levels.INFO)
end

-- <Space>af : Send current file reference (@relative/path) to agy pane
keymap("n", "<leader>af", function()
    local rel = vim.fn.expand("%:.")
    if rel == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    send_to_agy_pane("@" .. rel)
end, { desc = "Send @file reference to Antigravity CLI (agy)" })

-- <Space>as : Send visual line range (@relative/path#Lstart-Lend) to agy pane
keymap("v", "<leader>as", function()
    local rel = vim.fn.expand("%:.")
    if rel == "" then
        vim.notify("No file in current buffer", vim.log.levels.WARN)
        return
    end
    local l1 = vim.fn.line("v")
    local l2 = vim.fn.line(".")
    if l1 > l2 then l1, l2 = l2, l1 end
    local ref = string.format("@%s#L%d-L%d", rel, l1, l2)
    -- Exit visual mode cleanly before jumping to agy pane
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    send_to_agy_pane(ref)
end, { desc = "Send visual @file#L1-L2 selection to Antigravity CLI (agy)" })

-- -----------------------------------------------------------------------------
-- 4. Curated Minimal Plugins (Bootstrapped automatically via lazy.nvim)
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Nerd Font icons for Telescope and status UI
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Telescope: Blazing fast fuzzy file finder & ripgrep (<Space>ff, <Space>fg, <Space>fb)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")
            keymap("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            keymap("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep (ripgrep)" })
            keymap("n", "<leader>fb", builtin.buffers,    { desc = "Open buffers" })
            keymap("n", "<leader>fh", builtin.help_tags,  { desc = "Neovim help tags" })
            keymap("n", "<leader>fr", builtin.oldfiles,   { desc = "Recent files" })
        end,
    },

    -- Gitsigns: Live git gutter indicators & hunk previews (<Space>hp, <Space>hr, ]c, [c)
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gs = require("gitsigns")
            gs.setup({
                on_attach = function(bufnr)
                    keymap("n", "]c", gs.next_hunk, { buffer = bufnr, desc = "Next git hunk" })
                    keymap("n", "[c", gs.prev_hunk, { buffer = bufnr, desc = "Prev git hunk" })
                    keymap("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview git hunk" })
                    keymap("n", "<leader>hr", gs.reset_hunk,   { buffer = bufnr, desc = "Reset git hunk" })
                end,
            })
        end,
    },

    -- Oil.nvim: Edit directories like normal vi buffers (press '-' to open parent dir)
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({ view_options = { show_hidden = true } })
            keymap("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
        end,
    },
}, {
    checker = { enabled = false },
    change_detection = { notify = false },
})
