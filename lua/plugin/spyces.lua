local ids = {}

---Make the highlight group for concealing
local function makehl()
  vim.api.nvim_set_hl(0, 'SpyceConceal', { fg = 'bg' })
end

---Match concealment
---Check if the listchars field is set
---if not, conceal it with a matchadd;
---if true, remove the concealment with matchdelete
---@param lcs table listchars
---@param field string listchars field
---@param pattern string vim regex pattern to match
---@param force_conceal boolean|nil force concealment
local function _matchconceal(lcs, field, pattern, force_conceal)
  if not lcs[field] or force_conceal then
    ids[field] = vim.fn.matchadd('SpyceConceal', pattern, 0, -1)
  elseif ids[field] then
    vim.fn.matchdelete(ids[field])
    ids[field] = nil
  end
end

---Show spaces mixed with tabs, respect the original listchars settigns
local function matchconceal()
  local lcs = vim.opt.lcs:get()
  if not vim.opt.list:get() or lcs.space then
    return
  end
  vim.opt.lcs:append({ space = '·' })
  _matchconceal(lcs, 'space', [[\S\@1<=\ \S\@=]], true)
  _matchconceal(lcs, 'trail', [[\ \+$]])
  _matchconceal(lcs, 'precedes', [[^\ \+]])
  _matchconceal(lcs, 'multispace', [[\(^\ *\|\t\)\@<!\ \{2,}\(\ *$\|\t\)\@!]])
end

---Some autocmds to update highlight groups and change concealment
---under certain conditions
local function makehooks()
  vim.api.nvim_create_augroup('CatchSpyces', {})
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'ColorScheme' }, {
    group = 'CatchSpyces',
    callback = makehl,
  })
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'CatchSpyces',
    pattern = { '[vV\x16]*:*', '*:[vV\x16]*' },
    callback = function()
      if vim.fn.match(vim.v.event.new_mode, '[vV\x16]') ~= -1 then
        if ids.space then
          vim.fn.matchdelete(ids.space)
        end
      else
        matchconceal()
      end
    end,
  })
  vim.api.nvim_create_autocmd('OptionSet', {
    group = 'CatchSpyces',
    pattern = { 'list', 'listchars' },
    callback = matchconceal,
  })
end

---Initialize the plugin
local function init()
  makehl()
  matchconceal()
  makehooks()
end

return {
  init = init,
}
