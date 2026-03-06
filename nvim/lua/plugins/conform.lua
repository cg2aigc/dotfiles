-- lua/plugins/formatting.lua
return {
  "stevearc/conform.nvim",
  opts = {
    -- 强制 Python 使用 black
    -- python = { "black" },
    -- 强制 JS 使用 biome 而不是 prettier
    -- javascript = { "biome" },
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      vue = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      markdown = false,  -- 禁用 Markdown 格式化
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    default_format_opts = {
      timeout_ms = 2000,
      lsp_format = "fallback",  -- 没有格式化器时使用 LSP
    },
    -- format_on_save = {
    --   timeout_ms = 2000,
    --   lsp_format = "fallback",
    -- }
  }
}
