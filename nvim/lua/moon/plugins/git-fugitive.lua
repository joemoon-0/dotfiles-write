return {
    'https://github.com/tpope/vim-fugitive',
    config = function()
        local keymap = vim.keymap
        keymap.set("n", "<F2>", "<cmd>G blame<CR>", { desc = "Display Git Blame" })
    end,
}
