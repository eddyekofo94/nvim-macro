local ids = {}
local lcs = {}

---Make the highlight group for concealing
local function makehl()
  vim.api.nvim_set_hl(0, 'SpyceConceal', { fg = 'bg' })
end

---Match concealment
---Check if the listchars field is set
---if not, conceal it with a matchadd;
---if true, remove the concealment with matchdelete
---@param field string listchars field
---@param pattern string vim regex pattern to match
---@param force_add boolean|nil
local function _matchconceal(field, pattern, force_add)
  local win = vim.api.nvim_get_current_win()
  if force_add and not (ids[field] and ids[field][win]) or not lcs[field] then
    ids[field] = ids[field] or {}
    ids[field][win] = {
      vim.fn.matchadd('SpyceConceal', pattern, 0, -1),
      vim.api.nvim_get_current_win(),
    }
  elseif not force_add and lcs[field] and ids[field] and ids[field][win] then
    vim.fn.matchdelete(ids[field][win])
    ids[field][win] = nil
  end
end

---Show spaces mixed with tabs, respect the original listchars settigns
local function matchconceal()
  lcs = vim.opt.lcs:get()
  if not vim.opt.list:get() then
    return
  end
  vim.opt.lcs:append({ space = '·' })
  _matchconceal('space', [[\S\@1<=\ \S\@=]], true)
  _matchconceal('trail', [[\ \+$]])
  _matchconceal('lead', [[^\ \+]])
  _matchconceal('multispace', [[\(^\ *\|\t\)\@<!\ \{2,}\(\ *$\|\t\)\@!]])
end

---Match concealment for all windows
local function matchconceal_windo()
  vim.cmd('windo lua require("plugin.spyces").matchconceal()')
end

---Some autocmds to update highlight groups and change concealment
---under certain conditions
local function makehooks()
  vim.api.nvim_create_augroup('CatchSpyces', {})
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'ColorScheme' }, {
    group = 'CatchSpyces',
    callback = makehl,
  })
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
    group = 'CatchSpyces',
    callback = matchconceal,
  })
  vim.api.nvim_create_autocmd('OptionSet', {
    group = 'CatchSpyces',
    pattern = { 'list', 'listchars' },
    callback = function()
      if vim.v.option_type == 'global' then
        matchconceal_windo()
      else
        matchconceal()
      end
    end,
  })
end

---Initialize the plugin
local function init()
  makehl()
  matchconceal_windo()
  makehooks()
end

return {
  init = init,
  matchconceal = matchconceal,
}
