if true then return {} end
-- 禁用 Snacks Dashboard (避免冲突)
return { 
  "folke/snacks.nvim",
  opts = { 
    dashboard = { enabled = false }
  } 
}

