return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        -- 前端核心
        "typescript",
        "tsx",
        "javascript",
        "jsdoc",
        "html",
        "wxml",
        "css",
        "scss",
        "vue",
        "svelte",
        "astro",

        -- 配置文件
        "json",
        "jsonc",
        "json5",
        "yaml",
        "toml",

        -- 其他
        "lua",
        "graphql",
        "prisma",
        "bash",
        "regex",
        -- "markdown",
        -- "markdown_inline",
      })

      -- 启用增量选择
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      }

      -- 自动标签(重要!)
      opts.autotag = {
        enable = true,
        filetypes = {
          "html",
          "wxml",
          "xml",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
        },
      }

      -- 文本对象
      opts.textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["ap"] = "@parameter.outer",
            ["ip"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      }
    end,

    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },

  -- 自动标签插件
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },
}
