local M = {}

M.config = {}
M.lookup = {
    filetype = {},
    filename = {},
    dir      = {},
    lsp      = {}
}

function M.setup(opts)
    M.config = opts
end

function M.load()
    -- sub web-devicons
    package.loaded["nvim-web-devicons"] = require("easy-icons")

    -- build lookup table
    for type, items in pairs(M.config) do
        local table = type:match("^icon_(.+)")
        if M.lookup[table] then
            for entry, contents in pairs(items) do
                M.lookup[table][entry] = contents
            end
        else
            -- warn
        end
    end
end

return M
