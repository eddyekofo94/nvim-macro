-- Colorschemes other than the default colorscheme looks bad when the terminal
-- does not support truecolor
if vim.env.COLORTERM ~= 'truecolor' and vim.fn.has('gui_running') == 0 then
  return
end

-- Make sure that global variables BACKGROUND and COLORSNAME are saved to ShaDa
vim.opt_global.shada:prepend('!')

-- 1. Restore dark/light background and colorscheme from ShaDa so that nvim
--    "remembers" the background and colorscheme when it is restarted.
-- 2. Spawn setbg/setcolors on colorscheme change to make other nvim instances
--    and system color consistent with the current nvim instance.

local saved = utils.fs.read_json(colors_file)
  or {
    bg = 'dark',
    colors_name = 'nano',
  }

if saved.bg and saved.bg ~= vim.go.bg then
  vim.go.bg = saved.bg
end

if saved.colors_name and saved.colors_name ~= vim.g.colors_name then
  vim.cmd.colorscheme({
    args = { saved.colors_name },
    mods = { emsg_silent = true },
  })
end

local last_set ---@type integer?
local min_interval = 500 -- ms

vim.api.nvim_create_autocmd('Colorscheme', {
  group = vim.api.nvim_create_augroup('ColorSwitch', {}),
  desc = 'Spawn setbg/setcolors on colorscheme change.',
  callback = function()
    local now = vim.uv.now()
    if last_set and now - last_set < min_interval then
      return
    end
    last_set = now

    local data = utils.fs.read_json(colors_file)
    if data.colors_name ~= vim.g.colors_name or data.bg ~= vim.go.bg then
      data.colors_name = vim.g.colors_name
      data.bg = vim.go.bg
      if not utils.fs.write_json(colors_file, data) then
        return
      end
    end

    pcall(vim.system, { 'setbg', vim.go.bg })
    pcall(vim.system, { 'setcolors', vim.g.colors_name })
  end,
})
