-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "x", '"_x')
keymap("n", "0", "^", opts)
keymap("n", "9", "$", opts)

-- Increment/decrement
keymap("n", "+", "<C-a>")
keymap("n", "-", "<C-x>")

-- Select all
keymap("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
-- keymap("n", "<leader>fs", "<cmd>w<cr><esc>", { desc = "Save File" })
keymap({"n", "i"}, "<D-s>", "<esc>:update<Return>", opts)
keymap("n", "<Leader>q", ":quit<Return>", opts)
keymap("n", "<Leader>Q", ":qa<Return>", opts)

-- File explorer with NvimTree
-- keymap("n", "<Leader>fl", ":NvimTreeFindFile<Return>", opts)
-- keymap("n", "<Leader>e", ":NvimTreeToggle<Return>", opts)

-- Tabs
keymap("n", "te", ":tabedit")
keymap("n", "<tab>", ":tabnext<Return>", opts)
keymap("n", "<s-tab>", ":tabprev<Return>", opts)
keymap("n", "tw", ":tabclose<Return>", opts)

-- Split window
keymap("n", "_", ":split<Return>", opts)
keymap("n", "|", ":vsplit<Return>", opts)

-- Move window
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-l>", "<C-w>l")

-- Resize window
keymap("n", "<D-S-h>", "<C-w><")
keymap("n", "<D-S-l>", "<C-w>>")
keymap("n", "<D-S-k>", "<C-w>+")
keymap("n", "<D-S-j>", "<C-w>-")

-- ===== 前端开发快捷键 =====
-- TypeScript 工具
keymap("n", "<leader>t", "", { desc = "+TS" })
keymap("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organize Imports" })
keymap("n", "<leader>tu", "<cmd>TSToolsRemoveUnused<cr>", { desc = "Remove Unused" })
keymap("n", "<leader>ta", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add Missing Imports" })
keymap("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", { desc = "Fix All" })
keymap("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>", { desc = "Rename File" })

-- LSP 操作(补充 LazyVim 默认)
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
keymap("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
keymap("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

-- 格式化
keymap({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })
-- keymap("n", "<leader>fm", ":lua vim.lsp.buf.format()<CR>", { desc = "Format Code" })

-- 快速切换文件类型
keymap("n", "<leader>ft", function()
  local ft = vim.bo.filetype
  if ft == "typescript" then
    vim.bo.filetype = "typescriptreact"
  elseif ft == "typescriptreact" then
    vim.bo.filetype = "typescript"
  elseif ft == "javascript" then
    vim.bo.filetype = "javascriptreact"
  elseif ft == "javascriptreact" then
    vim.bo.filetype = "javascript"
  end
end, { desc = "Toggle TSX/JSX" })

-- 快速打开常用文件
-- keymap("n", "<leader>fp", "<cmd>e package.json<cr>", { desc = "Open package.json" })
-- keymap("n", "<leader>fv", "<cmd>e .env<cr>", { desc = "Open .env" })
-- keymap("n", "<leader>ft", "<cmd>e tsconfig.json<cr>", { desc = "Open tsconfig.json" })

-- REST 客户端
-- keymap("n", "<leader>rr", "<Plug>RestNvim", { desc = "Run REST Request" })
-- keymap("n", "<leader>rp", "<Plug>RestNvimPreview", { desc = "Preview REST Request" })

