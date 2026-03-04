return {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  priority = 100,
  opts = function(_, opts)
    local null_ls = require("null-ls")
    opts.sources = {
      null_ls.builtins.diagnostics.markdownlint_cli2.with({
        args = {
          "--config",
          os.getenv("HOME") .. "/.config/.lint/.markdownlint.jsonc",
          "--stdin-filename",
          "$FILENAME",
        },
      }),
    }
  end,
}
