-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.g.mapleader = " "
vim.g.autoformat = false
vim.g.root_spec = { "lsp", { ".git", "package.json", "lazyvim.json" }, "cwd" }
vim.g.lazyvim_picker = "telescope"

-- Enable this option to avoid conflicts with Prettier.
vim.g.lazyvim_prettier_needs_config = true

-- vim.g.node_host_prog = vim.fn.expand("~/.nvm/versions/node/v20.11.0/bin/node")

-- 取消窗口分隔线
-- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "NONE", bg = "NONE" })

local opt = vim.opt
opt.wrap = true

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.title = true
opt.ruler = false
opt.number = true
opt.numberwidth = 2
opt.cursorline = true
opt.cursorlineopt = "number"
opt.scrolloff = 5


opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true

opt.breakindent = true
opt.wrap = false

opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.smarttab = true

opt.showcmd = true
opt.cmdheight = 0
opt.laststatus = 0

opt.fillchars = { eob = " " }
opt.backspace = { "start", "eol", "indent" }

opt.path:append({ "**" })
opt.wildignore:append({ "*/node_modules/*" })

opt.inccommand = "split"
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "cursor"

opt.clipboard = "unnamedplus"
opt.mouse = "a"

opt.backup = false
opt.undofile = true
opt.timeoutlen = 400

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- disable nvim intro
opt.shortmess:append "sI"
-- Add asterisks in block comments
-- opt.formatoptions:append({ "r" })

opt.grepprg = "rg --vimgrep"  -- 使用 ripgrep
opt.grepformat = "%f:%l:%c:%m"

opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10  -- 补全菜单高度

opt.wildignore:append({
  "*/node_modules/*",
  "*/.git/*",
  "*/dist/*",
  "*/build/*",
  "*/.next/*",
  "*/.nuxt/*",
})
