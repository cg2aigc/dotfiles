-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- 前端文件检测
augroup("FrontendFileType", { clear = true })

autocmd({ "BufRead", "BufNewFile" }, {
  group = "FrontendFileType",
  pattern = { "*.jsx" },
  callback = function()
    vim.bo.filetype = "javascriptreact"
  end,
})

autocmd({ "BufRead", "BufNewFile" }, {
  group = "FrontendFileType",
  pattern = { "*.tsx" },
  callback = function()
    vim.bo.filetype = "typescriptreact"
  end,
})

-- 自动格式化(可选,根据 vim.g.autoformat 控制)
augroup("FormatOnSave", { clear = true })

autocmd("BufWritePre", {
  group = "FormatOnSave",
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.vue", "*.css", "*.scss", "*.json" },
  callback = function()
    if vim.g.autoformat then
      vim.lsp.buf.format({ async = false })
    end
  end,
})

-- 高亮 Yanked 文本
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 自动保存折叠
augroup("AutoSaveFolds", { clear = true })
autocmd("BufWinLeave", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! mkview",
})
autocmd("BufWinEnter", {
  group = "AutoSaveFolds",
  pattern = "*",
  command = "silent! loadview",
})
