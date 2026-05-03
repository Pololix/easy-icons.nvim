local M = {}

M.config = {}
M.lookup = {
    filestem  = {},
    filename  = {},
    extension = {},
    -- dir      = {},
    -- lsp      = {}
}

function M.setup(opts)
    M.config = opts
end

function M.load()
    -- sub web-devicons
    package.loaded["nvim-web-devicons"] = require("easy-icons")

    -- build lut
    for kind, items in pairs(M.config) do
        if M.lookup[kind] then
            for entry, desc in pairs(items) do
                M.lookup[kind][entry] = desc
            end
        else
            --warn
        end
    end
end

function M.has_loaded()
    return true
end

function M.get_icon(name, ext, opts)
    local stem = name:match("^(.*)%.")

    if stem and M.lookup.filestem[stem] then
        return M.lookup.filestem[stem].icon, M.lookup.filestem[stem].hl

    elseif M.lookup.filename[name] then
        return M.lookup.filename[name].icon, M.lookup.filename[name].hl

    elseif ext and M.lookup.extension[ext] then
        return M.lookup.extension[ext].icon, M.lookup.extension[ext].hl

    else
       return nil, nil
   end
end

function M.get_icon_color(name, ext, opts)
    local icon, hl = M.get_icon(name, ext, opts)
    return icon, hl
end

return M
