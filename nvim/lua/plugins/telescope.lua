return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      -- 支持带参数搜索，配置详见文档
      -- "nvim-telescope/telescope-live-grep-args.nvim",
    },
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      local custom = {}

      -- 复制相对路径
      custom.copy_relative_path = function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        local path = vim.fn.fnamemodify(entry.path, ":.")
        vim.fn.setreg("+", path)
        vim.notify("Copied relative path:\n" .. path)
      end

      -- 复制绝对路径
      custom.copy_absolute_path = function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        local path = vim.fn.fnamemodify(entry.path, ":p")
        vim.fn.setreg("+", path)
        vim.notify("Copied absolute path:\n" .. path)
      end

      opts.defaults = opts.defaults or {}

      -- 全局文件忽略模式
      opts.defaults.file_ignore_patterns = {
        -- 版本控制和依赖
        "%.git/",
        "node_modules/",

        -- macOS 系统目录
        "Library/",
        "Parallels/",
        "Pictures/",
        "Movies/",
        "Music/",

        -- 开发工具缓存
        "%.vscode/",
        "%.cache/",
        "%.local/",
        "%.npm/",
        "%.cursor/",
        "%.android/",
        "%.cocoapods/",
        "%.nvm/",
        "%.gradle/",
        "%.dartServer/",
        "%.pub%-cache/",
        "%.lingma/",
        "%.rvm/",
        "%.kiro/",
        "%.codeium/",
        "%.qoder/",

        -- config 子目录
        "coc/extensions/",
        "%.zim/",
        "%.zcompcache/",
        "configstore/",
        "clash/",
        "%.mono/",
        "%.isolated%-storage/",

        -- 临时文件
        "%.DS_Store",
        "%.zwc$",
        "%.zcompdump",
        "__pycache__/",
        "%.pyc$",
        "%.bak$",
        "%.old$",
        "%.swp$",
        "%.swo$",
        "_history$",
      }

      -- 自定义 UI 配置
      opts.defaults.prompt_prefix = " ⚡︎ "
      opts.defaults.selection_caret = " "
      opts.defaults.sorting_strategy = "ascending"
      opts.defaults.layout_config = vim.tbl_extend("force", opts.defaults.layout_config or {}, {
        prompt_position = "top",
      })

      -- Telescope insert 模式的按键
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings.i = vim.tbl_extend("force", opts.defaults.mappings.i or {}, {
        ["<C-y>"] = custom.copy_relative_path,   -- 复制相对路径
        ["<C-D-y>"] = custom.copy_absolute_path, -- 复制绝对路径
      })

      -- 配置文件查找命令，优化性能
      opts.pickers = opts.pickers or {}
      opts.pickers.find_files = {
        find_command = {
          "fd",
          "--type", "f",
          "--color", "never",
          "--hidden",
          "--exclude", ".git",
          "--exclude", "node_modules",
          "--exclude", "coc/extensions",
          "--exclude", ".zim/modules",
          "--exclude", ".isolated-storage",
          "--exclude", "configstore",
          "--exclude", "clash",
          "--exclude", ".DS_Store",
        },
      }

      return opts
    end,

    -- keys = {
    --   {
    --     "<leader>,",
    --     "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
    --     desc = "Switch Buffer",
    --   },
    --   { "<leader>/", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    --   { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    --   { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    --   -- find
    --   {
    --     "<leader>fb",
    --     "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
    --     desc = "Buffers",
    --   },
    --   { "<leader>fB", "<cmd>Telescope buffers<cr>", desc = "Buffers (all)" },
    --   { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
    --   { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    --   { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    --   { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
    --   { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    --   { "<leader>fR", LazyVim.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
    --   -- git
    --   { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    --   { "<leader>gl", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
    --   { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
    --   { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
    --   -- search
    --   { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    --   { "<leader>s/", "<cmd>Telescope search_history<cr>", desc = "Search History" },
    --   { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    --   { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Lines" },
    --   { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    --   { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    --   { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    --   { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
    --   { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    --   { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
    --   { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    --   { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    --   { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
    --   { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    --   { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
    --   { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    --   { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    --   { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    --   { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    --   { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
    --   { "<leader>sw", LazyVim.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
    --   { "<leader>sW", LazyVim.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
    --   { "<leader>sw", LazyVim.pick("grep_string"), mode = "x", desc = "Selection (Root Dir)" },
    --   { "<leader>sW", LazyVim.pick("grep_string", { root = false }), mode = "x", desc = "Selection (cwd)" },
    --   { "<leader>uC", LazyVim.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
    --   {
    --     "<leader>ss",
    --     function()
    --       require("telescope.builtin").lsp_document_symbols({
    --         symbols = LazyVim.config.get_kind_filter(),
    --       })
    --     end,
    --     desc = "Goto Symbol",
    --   },
    --   {
    --     "<leader>sS",
    --     function()
    --       require("telescope.builtin").lsp_dynamic_workspace_symbols({
    --         symbols = LazyVim.config.get_kind_filter(),
    --       })
    --     end,
    --     desc = "Goto Symbol (Workspace)",
    --   },
    -- },
    -- opts = function(_, opts)
    --   local actions = require("telescope.actions")
    --
    --   local open_with_trouble = function(...)
    --     return require("trouble.sources.telescope").open(...)
    --   end
    --   local find_files_no_ignore = function()
    --     local action_state = require("telescope.actions.state")
    --     local line = action_state.get_current_line()
    --     LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
    --   end
    --   local find_files_with_hidden = function()
    --     local action_state = require("telescope.actions.state")
    --     local line = action_state.get_current_line()
    --     LazyVim.pick("find_files", { hidden = true, default_text = line })()
    --   end
    --
    --   local function find_command()
    --     if 1 == vim.fn.executable("rg") then
    --       return { "rg", "--files", "--color", "never", "-g", "!.git" }
    --     elseif 1 == vim.fn.executable("fd") then
    --       return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
    --     elseif 1 == vim.fn.executable("fdfind") then
    --       return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
    --     elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
    --       return { "find", ".", "-type", "f" }
    --     elseif 1 == vim.fn.executable("where") then
    --       return { "where", "/r", ".", "*" }
    --     end
    --   end
    --
    --   return {
    --     defaults = {
    --       prompt_prefix = " ⚡︎",
    --       selection_caret = " ",
    --       layout_config = {
    --         prompt_position = "top",
    --       },
    --       -- open files in the first window that is an actual file.
    --       -- use the current window if no other window is available.
    --       get_selection_window = function()
    --         local wins = vim.api.nvim_list_wins()
    --         table.insert(wins, 1, vim.api.nvim_get_current_win())
    --         for _, win in ipairs(wins) do
    --           local buf = vim.api.nvim_win_get_buf(win)
    --           if vim.bo[buf].buftype == "" then
    --             return win
    --           end
    --         end
    --         return 0
    --       end,
    --       mappings = {
    --         i = {
    --           ["<c-t>"] = open_with_trouble,
    --           ["<a-t>"] = open_with_trouble,
    --           ["<a-i>"] = find_files_no_ignore,
    --           ["<a-h>"] = find_files_with_hidden,
    --           ["<C-Down>"] = actions.cycle_history_next,
    --           ["<C-Up>"] = actions.cycle_history_prev,
    --           ["<C-f>"] = actions.preview_scrolling_down,
    --           ["<C-b>"] = actions.preview_scrolling_up,
    --         },
    --         n = {
    --           ["q"] = actions.close,
    --         },
    --       },
    --     },
    --     pickers = {
    --       find_files = {
    --         find_command = find_command,
    --         hidden = true,
    --       },
    --     },
    --   }
    -- end,
  },
}
