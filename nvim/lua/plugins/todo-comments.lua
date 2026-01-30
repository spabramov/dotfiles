return {
    -- Highlight todo, notes, etc in comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        enabled = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
}
