return {
    'rcarriga/nvim-notify',
    config = function()
        local notify = require 'notify'

        local filtered_message = { 'No information available' }

        -- Override notify function to filter out messages
        ---@diagnostic disable-next-line: duplicate-set-field

        local default_opts = {
            on_open = function(win)
                local buf = vim.api.nvim_win_get_buf(win)
                vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
            end,
        }
        -- Override notify function to filter out messages
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.notify = function(message, level, opts)
            local merged_opts = vim.tbl_extend('force', default_opts, opts or {})

            for _, msg in ipairs(filtered_message) do
                if message == msg then
                    return
                end
            end

            return notify(message, level, merged_opts)
        end
        notify.setup { background_colour = '#000000' }
    end,
}
