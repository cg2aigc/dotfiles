-- if true then return {} end
-- 禁用 Snacks Dashboard (避免冲突)

---@module "lazy"
---@type LazySpec
return { 
  "folke/snacks.nvim",
  priority = 1000,

  ---@type snacks.Config
  opts = { 
    picker = {
      win = {
        input = {
          keys = {
            ["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
          },
        },
      },
    },
    dashboard = { enabled = false }
  } 
}

