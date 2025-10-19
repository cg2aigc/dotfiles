-- lua/plugins/formatting.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- 强制 Python 使用 black
      -- python = { "black" },
      -- 强制 JS 使用 biome 而不是 prettier
      -- javascript = { "biome" },
      -- 对 Markdown 禁用格式化
      markdown = false, 
    },
  },
}
