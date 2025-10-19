-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.colorscheme = "tokyonight"
-- lvim.transparent_window = true


-- LSP --
-- add `pyright` to `skipped_servers` list
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- remove `jedi_language_server` from `skipped_servers` list
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "jedi_language_server"
end, lvim.lsp.automatic_configuration.skipped_servers)


-- Plugins --
lvim.plugins = {
  -- live edit html, css, and javascript
  {
    "turbio/bracey.vim",
    cmd = {"Bracey", "BracyStop", "BraceyReload", "BraceyEval"},
    build = "npm install --prefix server",
  },
  -- underlines the word under the cursor
  {
    "itchyny/vim-cursorword",
    event = {"BufEnter", "BufNewFile"},
    config = function()
      vim.api.nvim_command("augroup user_plugin_cursorword")
      vim.api.nvim_command("autocmd!")
      vim.api.nvim_command("autocmd FileType NvimTree,lspsagafinder,dashboard,vista let b:cursorword = 0")
      vim.api.nvim_command("autocmd WinEnter * if &diff || &pvw | let b:cursorword = 0 | endif")
      vim.api.nvim_command("autocmd InsertEnter * let b:cursorword = 0")
      vim.api.nvim_command("autocmd InsertLeave * let b:cursorword = 1")
      vim.api.nvim_command("augroup END")
    end
  },
  -- enable repeating supported plugin maps with "."
  { "tpope/vim-repeat" },
  -- mappings to delete, change and add surroundings
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- init = function()
      --  vim.o.timeoutlen = 500
    -- end
  },
  -- neovim motions on speed!
  {
    "phaazon/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  -- jetpack codebase navigation
  {
    "ggandor/lightspeed.nvim",
    event = "BufRead",
  },
  -- jump to the line
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },
  -- search and replace
  {
    "nvim-pack/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  -- navigate and highlight matching words
  -- -- enable treesitter integration
  -- lvim.builtin.treesitter.matchup.enable = true
  {
    "andymass/vim-matchup",
    event = "CursorMoved",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  -- fast finder system
  -- {
  --   "camspiers/luarocks",
  --   opts = { rocks = { "fzy" } },
  -- },
  {
    "camspiers/snap",
    config = function()
      local snap = require("snap")
      local layout = snap.get("layout").bottom
      local file = snap.config.file:with { reverse = true, suffix = ">>", consumer = "fzf", layout = layout }
      local vimgrep = snap.config.vimgrep:with { reverse = true, suffix = ">>", limit = 500, layout = layout }
      snap.register.command("find_files", file { producer = "ripgrep.file" })
      snap.register.command("buffers", file { producer = "vim.buffer" })
      snap.register.command("oldfiles", file { producer = "vim.oldfile" })
      snap.register.command("live_grep", vimgrep {})
    end,
    -- dependencies = { "camspiers/luarocks" },
  },
  -- ranger file explorer window
  {
    "kevinhwang91/rnvimr",
    cmd = "RnvimrToggle",
    config = function()
      vim.g.rnvimr_draw_border = 1
      vim.g.rnvimr_pick_enable = 1
      vim.g.rnvimr_bw_enable = 1
    end,
  },
  -- git wrapper
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = {"fugitive"}
  },
  -- git diff in a single tabpage
  {
    "sindrets/diffview.nvim",
    event = "BufRead",
  },
  -- show git blame
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup { enabled = false }
    end,
  },
  -- better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
  },
  -- switch between projects
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    init = function()
      -- vim.cmd [[packadd "nvim-telescope/telescope.nvim"]]
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-telescope/telescope-fzy-native.nvim"
    }
  },
  -- preview markdown in the browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = "markdown",
    config = function()
      vim.g.mkdp_auto_start = 1
    end,
  },
  -- commentstring option based on the cursor location
  -- {
  --   "JoosepAlviste/nvim-ts-context-commentstring",
  --   event = "BufRead",
  -- },
  -- highlight and search for todo comments
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- rainbow parentheses
  -- lvim.builtin.treesitter.rainbow.enable = true
  {
    "mrjones2014/nvim-ts-rainbow",
  },
  -- lsp diagnostics highlight groups for non lsp colorschemes
  {
    "folke/lsp-colors.nvim",
    event = "BufRead",
  },
  -- color highlighter
  {
    "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        })
    end,
  },
}

-- Lualine --
-- You can use any component that lualine provides and LunarVim provides.
-- LunarVim's components
-- mode, branch, filename, diff, python_env, diagnostics, treesitter, lsp, location, progress, spaces, encoding, filetype, scrollbar
-- To set lualine's "diff" component to section c of "default" style,
lvim.builtin.lualine.style = "default"
lvim.builtin.lualine.sections.lualine_c = { "diff" }

-- register your extension : --
lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  -- any other extensions loading
end
