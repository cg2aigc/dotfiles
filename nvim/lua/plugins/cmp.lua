return {
  -- nvim-cmp: 自动补全引擎
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",      -- LSP 补全源
      "hrsh7th/cmp-buffer",         -- 缓冲区补全
      "hrsh7th/cmp-path",           -- 路径补全
      "hrsh7th/cmp-emoji",          -- Emoji 补全
      "saadparwaiz1/cmp_luasnip",   -- Snippet 补全
    },
    opts = function(_, opts)
      -- 添加 emoji 补全源
      table.insert(opts.sources, { name = "emoji" })
      return opts
    end,
  },

  -- LuaSnip: 代码片段引擎
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",  -- 预定义代码片段
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
