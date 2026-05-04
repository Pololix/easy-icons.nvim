-- opt:
-- build from the user input pattern so everything is
-- pattern = { "x", "hl" }
-- easy get_icon func




---@diagnostic disable: undefined-global
local M = {}

M.otps = {}
M.lookup = {
    name         = {}, -- name and extension
    pattern_name = {}, -- files with the same extension and pattern in the stem
    stem         = {}, -- name regardless of the extension
    pattern_stem = {}, -- files with the same pattern in the stem regardless of extension
    ext          = {}, -- extension regardless of the name
}

function M.setup(opts)
    M.opts = opts
    M.load()
end

function M.load()
    -- build lut
    for kind, items in pairs(M.opts) do
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

---@diagnostic disable-next-line: unused-local
function M.get_icon(name, ext, opts)
    -- get strings before (stem) and after (_ext) the last dot
    local stem, _ext = name:match("^(.+)%.([^%.]+)$")

    -- if theres no stem is a dotfile without extension
    if not stem then
        stem = name
    end

    -- treat no extension as a group itself -> access via ["NO_EXT"]
    if not _ext then
        _ext = "NO_EXT"
    end

    -- check against every recorded pattern (pray for no matching patterns)
    local lt = M.lookup

    local sp     = ""
    local has_sp = false
    local np     = ""
    local has_np = false

    for pattern, _ in pairs(lt.pattern_stem) do
        if stem:match(pattern) then
            sp = pattern
            has_sp = true
            goto continue
        end
    end

    for pattern, _ in pairs(lt.pattern_name) do
        if name:match(pattern) then
            np = pattern
            has_np = true
            goto continue
        end
    end

    ::continue::

    if lt.stem[stem] then
        return lt.stem[stem].icon, lt.stem[stem].hl
    elseif has_sp then
        return lt.pattern_stem[sp].icon, lt.pattern_stem[sp].hl
    elseif lt.name[name] then
        return lt.name[name].icon, lt.name[name].hl
    elseif has_np then
        return lt.pattern_name[np].icon, lt.pattern_name[np].hl
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
