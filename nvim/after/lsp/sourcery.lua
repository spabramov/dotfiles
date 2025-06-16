return {
    cmd = { 'sourcery' },
    args = { 'lsp' },
    initializationOptions = {
        editor_version = 'vim',
    },
    settings = {
        sourcery = {
            metricsEnabled = true,
        },
    },
    filetypes = { 'python' },
}
