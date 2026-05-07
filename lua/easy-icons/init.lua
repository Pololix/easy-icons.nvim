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
        M.lookup.name[M.create_pattern(name, true)] = M.resolve(desc, name)
    end

    for stem, desc in pairs(M.opts.stem) do
        M.lookup.stem[M.create_pattern(stem, false)] = M.resolve(desc, stem)
    end

    for ext, desc in pairs(M.opts.ext) do
        M.lookup.ext[ext] = M.resolve(desc, ext)
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

    local hi = vim.api.nvim_get_hl(0, { name = hl, link = false })
    local hex = hi.fg and string.format("#%06x", hi.fg) or nil

    return icon, hex
end

function M.create_pattern(input, cap)
    input = input:gsub("([%.%+%-%*%?%[%]%^%$%(%)%%])", "%%%1")
    input = input:gsub("%$", ".+") -- $ defines a rule (mandatory)
    input = input:gsub("&", ".*") -- & defines a posibily (optional)

    local cap_char = "$"
    if not cap then
        cap_char = "%."
    end

    return "^" .. input .. cap_char
end

function M.resolve(desc, entry)
    if (desc.hl):match("^#%x%x%x%x%x%x$") then
        entry = entry:gsub("[^%w]", "")
        local hl = "EasyIcons_" .. entry
        vim.api.nvim_set_hl(0, hl, { fg = desc.hl })
        desc.hl = hl
    end
    return desc
end

return M
