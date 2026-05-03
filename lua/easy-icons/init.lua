local M = {}

M.config = {}
M.lookup = {
    stem = {},
    name = {},
    ext  = {},
}

function M.setup(opts)
    M.config = opts
    M.load()
end

function M.load()
    -- build lut
    for kind, items in pairs(M.config) do
        if M.lookup[kind] then
            for entry, desc in pairs(items) do
                if type(desc.hl) == "string" and desc.hl:match("^#%x%x%x%x%x%x") then
                    local name = "EasyIcons" .. entry
                    vim.api.nvim_set_hl(0, name, { fg = desc.hl })
                    desc.hl = name
                end
                M.lookup[kind][entry] = desc
            end
        end
    end

    vim.g.loaded_easy_icons = true
end

function M.has_loaded()
    return vim.g.loaded_easy_icons
end

function M.get_icon(name, ext, opts)
    local stem, _ext = name:match("^(.+)%.([^%.]+)$")
    if not stem then
        stem = name
    end

    if not _ext then
        _ext = "NO_EXT"
    end

    local lt = M.lookup
    if lt.stem[stem] then
        return lt.stem[stem].icon, lt.stem[stem].hl
    elseif lt.name[name] then
        return lt.name[name].icon, lt.name[name].hl
    elseif lt.ext[_ext] then
        return lt.ext[_ext].icon, lt.ext[_ext].hl
    else
        return nil, nil
    end
end

function M.get_icon_color(name, ext, opts)
    local icon, hl = M.get_icon(name, ext, opts)
    if not hl then
        return icon, nil
    end

    local hi = vim.api.nvim_get_hl(0, { name = hl, link = false })
    local hex = hi.fg and string.format("#%06x", hi.fg) or nil

    return icon, hex
end

return M
