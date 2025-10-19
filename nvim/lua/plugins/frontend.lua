return {
  -- 1. 自动括号配对
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,  -- 使用 Treesitter
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
      },
    },
  },

  -- 2. Package.json 管理
  {
    "vuki656/package-info.nvim",
    event = "BufRead package.json",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
      { "<leader>p", "", desc = "+NPM" },
      { "<leader>pu", function() require("package-info").update() end, desc = "Update Package" },
      { "<leader>pd", function() require("package-info").delete() end, desc = "Delete Package" },
      { "<leader>pi", function() require("package-info").install() end, desc = "Install Package" },
      { "<leader>pc", function() require("package-info").change_version() end, desc = "Change Version" },
    },
  },

  -- 4. Tailwind 颜色预览
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        RGB = true,
        RRGGBB = true,
        names = false,
        RRGGBBAA = true,
        AARRGGBB = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true,
        mode = "background",
        tailwind = true,
        sass = { enable = true, parsers = { "css" } },
        virtualtext = "■",
      },
    },
  },

  -- 5. REST 客户端(测试 API) - 使用 kulala.nvim (无需 luarocks)
  {
    "mistweaverco/kulala.nvim",
    ft = "http",
    keys = {
      { "<leader>r", "", desc = "+RestRequest" },
      { "<leader>rr", "<cmd>lua require('kulala').run()<cr>", desc = "Run REST Request" },
      { "<leader>ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "Run All Requests" },
      { "<leader>ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "Inspect Request" },
      { "<leader>rc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy as cURL" },
    },
    opts = {
      default_view = "body",
      formatters = {
        json = { "jq", "." },
        html = { "prettier", "--parser", "html" },
      },
    },
  },

  -- 6. Git Signs 增强
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
      },
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },

  -- 7. Tmux 导航
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },
}
