local M = {}

M.lookup = {}
M.otps = {}

function M.setup(opts)
end

function M.load()
end

function M.get_icon(name, ext, opts)
end

function M.get_icon_color(name, ext, opts)
    local icon, hl = M.get_icon(name, ext, opts)

    if not icon then
        return nil, nil
    end

    if not hl then
        return icon, nil
    end

    local hi = vim.api.nvim_get_hl(0, { name = hl, link = false })
    local hex = hi.fg and string.format("#%06x", hi.fg) or nil

    return icon, hex
end

return M
