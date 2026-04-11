return {
  "pablopunk/pi.nvim",
  cmd = { "PiAsk", "PiAskSelection", "PiCancel", "PiLog" },
  keys = {
    { "<leader>aa", "<cmd>PiAsk<cr>", desc = "Ask pi" },
    { "<leader>as", ":<C-u>PiAskSelection<cr>", mode = "v", desc = "Ask pi about selection" },
  },
  opts = function()
    return {
      -- Recommended: inherit provider/model from your existing pi CLI config.
      -- This lets pi.nvim use the same authenticated provider you already use.
      log_path = vim.fn.stdpath("state") .. "/pi-nvim.log",
    }
  end,
}
