return {
  -- 禁用 Snacks Dashboard
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },

  -- 配置 dashboard-nvim
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      -- local logo = [[
      -- ██████╗ ███████╗ ██████╗  ██████╗ ██╗   ██╗          Z
      -- ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗██║   ██║      Z    
      -- ██║  ██║█████╗  ██║  ███╗██║   ██║██║   ██║   z       
      -- ██║  ██║██╔══╝  ██║   ██║██║   ██║██║   ██║ z         
      -- ██████╔╝██║     ╚██████╔╝╚██████╔╝╚██████╔╝           
      -- ╚═════╝ ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝            
      -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      -- 🚀 C's Development Workspace
      -- ]]

      -- Hollywood
      --[[
                                                                              
                    /'                                                       
                  /'                /')                                      
          _____,/'                /' /'           ____      ____             
        /'    /'               -/'--'           /'    )   /'    )--   /'    /
      /'    /'                /'              /'    /'  /'    /'    /'    /' 
      (___,/(__              /(_____          (___,/(__ (___,/'     (___,/(__ 
                          /'                    /'                           
                        /'              /     /'                             
                      /'               (___,/'                               
      --]]
      --[[
                    _                 _              _                         
                  /' `\             /' `\          /' `\                       
                /'     )          /'   ._)       /'     )                      
              /'      /'       ,/'             /'             ____             
            /'      /'        /`---,         /'   _         /'    )--   /'    /
          /'      /'        /'             /'    ' )      /'    /'    /'    /' 
      (,/' (___,/'      (,/'              (_____,/'      (___,/'     (___,/(__ 
                                                                              
                                                                              
                                                                              
      --]]

      -- Peaks slant
      --[[
          _/\/\/\/\/\___     _/\/\/\/\/\/\_     ___/\/\/\/\/\_     ____________     ____________
          _/\/\____/\/\_     _/\/\_________     _/\/\_________     ___/\/\/\___     _/\/\__/\/\_ 
        _/\/\____/\/\_     _/\/\/\/\/\___     _/\/\__/\/\/\_     _/\/\__/\/\_     _/\/\__/\/\_  
        _/\/\____/\/\_     _/\/\_________     _/\/\____/\/\_     _/\/\__/\/\_     _/\/\__/\/\_   
      _/\/\/\/\/\___     _/\/\_________     ___/\/\/\/\/\_     ___/\/\/\___     ___/\/\/\/\_    
      ______________     ______________     ______________     ____________     ____________     
      --]]

      local logo = [[
                ___________     _____       ______                
      |``````.  |             .-~     ~.   .~      ~.  |         | 
      |       | |______      :            |          | |         | 
      |       | |            :     _____  |          | |         | 
      |......'  |             `-._____.'|  `.______.'  `._______.' 
                                                                  
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = true,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            { action = 'lua LazyVim.pick()()',                           desc = " Find File",       icon = " ", key = "f" },
            -- { action = "Telescope file_browser", desc = " Browse Files", icon = " ", key = "b" },
            { action = 'lua LazyVim.pick("oldfiles")()',                 desc = " Recent Files",    icon = " ", key = "r" },
            { action = 'lua LazyVim.pick("live_grep")()',                desc = " Find Text",       icon = " ", key = "g" },
            -- { action = "terminal", desc = " Terminal", icon = " ", key = "t" },
            { action = 'lua require("persistence").load()',              desc = " Restore Session", icon = " ", key = "s" },
            { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
            { action = "LazyExtras",                                     desc = " Lazy Extras",     icon = " ", key = "x" },
            { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            local version = vim.version()
            local nvim_version = " v" .. version.major .. "." .. version.minor .. "." .. version.patch

            return { 
              "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
              " Neovim" .. nvim_version .. " 🔥 Full Stack Develop"
            }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- open dashboard after closing lazy
      if vim.o.filetype == "lazy" then
        vim.api.nvim_create_autocmd("WinClosed", {
          pattern = tostring(vim.api.nvim_get_current_win()),
          once = true,
          callback = function()
            vim.schedule(function()
              vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
            end)
          end,
        })
      end

      return opts
    end,
  },
}
