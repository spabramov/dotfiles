return {
    {
        'preservim/vim-markdown',
        enabled = false,
        dependencies = { 'godlygeek/tabular' },
        config = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0

            vim.g.vim_markdown_frontmatter = 1      -- for YAML format
            vim.g.vim_markdown_toml_frontmatter = 1 -- for TOML format
            vim.g.vim_markdown_json_frontmatter = 1 -- for JSON format
        end
    },
    {
        'vim-pandoc/vim-pandoc-syntax',
        -- dependencies = { 'vim-pandoc/vim-pandoc' }
    }
}
