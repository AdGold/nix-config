return {
  {
    event = "User InGitRepo",
    "tpope/vim-fugitive"
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "User InGitRepo",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
      vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", {})
    end
  }
}
