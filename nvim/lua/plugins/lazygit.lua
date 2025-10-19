return {
    "kdheepak/lazygit.nvim",
    lazy = false,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>gg",
        function()
          local Util = require("lazyvim.util")
          Util.terminal.open({ "lazygit" }, { cwd = Util.root.get() })
        end,
        desc = "Open Lazygit (Project Root)",
      },
    },
    config = function()
        require("telescope").load_extension("lazygit")
    end,
}
