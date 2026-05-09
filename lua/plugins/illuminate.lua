return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local illuminate = require("illuminate")

    pcall(vim.api.nvim_del_keymap, "n", "a-n")
    pcall(vim.api.nvim_del_keymap, "n", "a-p")

    vim.keymap.set("n", "[r", illuminate.goto_prev_reference, { desc = "Previous Reference" })
    vim.keymap.set("n", "]r", illuminate.goto_next_reference, { desc = "Next Reference" })
  end,
}
