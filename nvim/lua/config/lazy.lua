local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins", opts = {
				colorscheme = "catppuccin",
				news = {
					lazyvim = true,
					neovim = true,
				},
			},
    },
    
    -- === 前端核心 Extras ===
    -- 语言支持
    { import = "lazyvim.plugins.extras.lang.typescript" },      -- TS/JS
    { import = "lazyvim.plugins.extras.lang.json" },            -- JSON
    { import = "lazyvim.plugins.extras.lang.tailwind" },        -- Tailwind CSS
    { import = "lazyvim.plugins.extras.lang.vue" },             -- Vue 2/3

    -- 格式化与 Linting
    { import = "lazyvim.plugins.extras.formatting.prettier" },  -- Prettier
    { import = "lazyvim.plugins.extras.linting.eslint" },       -- ESLint
    -- { import = "lazyvim.plugins.extras.formatting.biome" },  -- 或使用 Biome (更快)

    -- LSP 增强
    { import = "lazyvim.plugins.extras.lsp.none-ls" },          -- none-ls 支持

    -- DAP
    { import = "lazyvim.plugins.extras.dap.core" },

    -- 编码增强
    { import = "lazyvim.plugins.extras.coding.mini-surround" }, -- 快速包围 (gsa/gsd/gsr)

    -- UI 增强
    { import = "lazyvim.plugins.extras.ui.mini-indentscope" },  -- 缩进可视化
    -- 颜色高亮使用 nvim-colorizer.lua (在 frontend.lua 中配置)

    -- 编辑器增强
    { import = "lazyvim.plugins.extras.editor.illuminate" },    -- 高亮相同词
    { import = "lazyvim.plugins.extras.editor.inc-rename" },    -- 重命名预览
    -- { import = "lazyvim.plugins.extras.editor.telescope" },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "tokyonight" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates

  -- Luarocks 配置 (按需自动安装 Lua 5.1)
  -- 当前所有插件都是纯 Lua，不需要 luarocks
  -- 如果将来安装需要编译的插件，LazyVim 会自动安装 hererocks
  rocks = {
    enabled = false,
    hererocks = false,  -- 自动安装 Lua 5.1 和 luarocks (按需) 需要开启选项（true）
  },

  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
