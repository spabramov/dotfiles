---@type vim.lsp.Config
return {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "recommended",
                diagnosticSeverityOverrides = {
                    reportAny = false,
                    reportExplicitAny = false,
                    reportUnknownMemberType = false,
                },
                inlayHints = {
                    variableTypes = false,
                    genericTypes = false,
                    callArgumentNames = true
                }
            },
        }
    }
}
