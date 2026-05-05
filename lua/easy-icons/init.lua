local M  = {}

M.lookup = {
    name = {},
    stem = {},
    ext  = {}
}
M.opts   = {
    name = {},
    stem = {},
    ext  = {}
}

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
    M.load()
end

function M.load()
    M.lookup = { name = {}, stem = {}, ext = {} }
    for name, desc in pairs(M.opts.name) do
        local pattern = "^" .. name:gsub("%%", ".+") .. "$"
        M.lookup.name[pattern] = desc
    end

    for stem, desc in pairs(M.opts.stem) do
        local pattern = "^" .. stem:gsub("%%", ".+") .. "%."
        M.lookup.stem[pattern] = desc
    end

    for ext, desc in pairs(M.opts.ext) do
        M.lookup.ext[ext] = desc
    end

    vim.g.loaded_easy_icons = true
end

function M.has_loaded()
    return vim.g.loaded_easy_icons
end

function M.get_icon(name, _, _)
    for pattern, desc in pairs(M.lookup.name) do
        if name:match(pattern) then
            return desc.icon, desc.hl
        end
    end
    for pattern, desc in pairs(M.lookup.stem) do
        if name:match(pattern) then
            return desc.icon, desc.hl
        end
    end

    local ext = name:match(".*%.(.+)$")
    local lt  = M.lookup.ext[ext]
    if lt then
        return lt.icon, lt.hl
    end
end

function M.get_icon_color(name, ext, opts)
    local icon, hl = M.get_icon(name, ext, opts)

    if not icon then
        return nil, nil
    elseif not hl then
        return icon, nil
    end

    local hex = ""
    if not hl:match("#%06x") then
        local hi = vim.api.nvim_get_hl(0, { name = hl, link = false })
        hex = hi.fg and string.format("#%06x", hi.fg) or nil
    else
        hex = hl
    end

    return icon, hex
end

return M
