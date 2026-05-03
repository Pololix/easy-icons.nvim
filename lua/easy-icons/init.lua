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
    -- sub web-devicons
    if not vim.g.loaded_easy_icons then
        package.loaded["nvim-web-devicons"] = require("easy-icons")
    end

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
    local stem = ""
    local pre = name:match("^(.*)%.")
    if pre and pre ~= "" then
        stem = pre
    else
        stem = name
    end

    if not ext or ext == "" then
        ext = "NO_EXT"
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
