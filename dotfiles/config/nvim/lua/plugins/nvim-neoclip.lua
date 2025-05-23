return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    { "kkharji/sqlite.lua",           module = "sqlite" },
    { "nvim-telescope/telescope.nvim" },
  },
  config = function()
    require("neoclip").setup({
      enable_persistent_history = true,
      continuous_sync = true,
    })
    vim.keymap.set("n", "<leader>p", ":Telescope neoclip<CR>", {})
  end,
}
