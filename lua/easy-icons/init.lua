local M = {}

M.config = {}
M.lookup = {
    stem = {},
    name = {},
    ext  = {},
}

function M.setup(opts)
    M.config = opts
end

function M.load()
    -- sub web-devicons
    if not vim.g.easy_icons_loaded then
        package.loaded["nvim-web-devicons"] = require("easy-icons")
    end

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

    M.status = true
end

function M.has_loaded()
    return vim.g.easy_icons_loaded
end

function M.get_icon(name, ext, opts)
    local stem = ""
    local pre = name:match("^(.*)%.")

    if pre and pre ~= "" then
        stem = pre
    else
        stem = name
    end

    local lt = M.lookup
    if lt.stem[stem] then
        return lt.stem[stem].icon, lt.stem[stem].hl
    elseif lt.name[name] then
        return lt.name[name].icon, lt.name[name].hl
    elseif lt.ext[ext] then
        return lt.ext[ext].icon, lt.ext[ext].hl
    else
        return nil, nil
    end
end

function M.get_icon_color(name, ext, opts)
    local icon, hl = M.get_icon(name, ext, opts)
    return icon, hl
end

return M
