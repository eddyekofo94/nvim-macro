local M = {}

--- regex used for matching a valid URL/URI string
M.url_matcher =
  "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

--- Delete the syntax matching rules for URLs/URIs if set
---@param win integer? the window id to remove url highlighting in (default: current window)
function M.delete_url_match(win)
  if not win then
    win = vim.api.nvim_get_current_win()
  end
  for _, match in ipairs(vim.fn.getmatches(win)) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id, win)
    end
  end
  vim.w[win].highlighturl_enabled = false
end

--- Add syntax matching rules for highlighting URLs/URIs
---@param win integer? the window id to remove url highlighting in (default: current window)
function M.set_url_match(win)
  if not win then
    win = vim.api.nvim_get_current_win()
  end
  M.delete_url_match(win)
  vim.fn.matchadd("HighlightURL", M.url_matcher, 15, -1, { window = win })
  vim.w[win].highlighturl_enabled = true
end

function M.starts_with(str, start)
  return str:sub(1, #start) == start
end

function M.is_table(to_check)
  return type(to_check) == "table"
end

function M.has_key(t, key)
  for t_key, _ in pairs(t) do
    if t_key == key then
      return true
    end
  end
  return false
end

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

function M.has_value(t, val)
  for _, value in ipairs(t) do
    if value == val then
      return true
    end
  end
  return false
end

function M.tprint(table)
  print(vim.inspect(table))
end

function M.tprint_keys(table)
  for k in pairs(table) do
    print(k)
  end
end
---runs :normal with bang
---@param cmdStr string
function M.normal(cmdStr)
  vim.cmd.normal { cmdStr, bang = true }
end

local function escape(str)
  return str:gsub("%%", "%%%%")
end

--- Partially reload AstroNvim user settings. Includes core vim options, mappings, and highlights. This is an experimental feature and may lead to instabilities until restart.
---@param quiet? boolean Whether or not to notify on completion of reloading
---@return boolean # True if the reload was successful, False otherwise
function M.reload(quiet)
  local was_modifiable = vim.opt.modifiable:get()
  if not was_modifiable then
    vim.opt.modifiable = true
  end
  local core_modules = { "plugins", "autocommands", "keymaps" }
  local modules = vim.tbl_filter(function(module)
    return module:find "^user%."
  end, vim.tbl_keys(package.loaded))

  vim.tbl_map(require("plenary.reload").reload_module, vim.list_extend(modules, core_modules))

  local success = true
  for _, module in ipairs(core_modules) do
    local status_ok, fault = pcall(require, module)
    if not status_ok then
      vim.api.nvim_err_writeln("Failed to load " .. module .. "\n\n" .. fault)
      success = false
    end
  end
  if not was_modifiable then
    vim.opt.modifiable = false
  end
  if not quiet then -- if not quiet, then notify of result
    if success then
      M.notify("Config successfully reloaded", "info")
    else
      M.notify("Error reloading Config...", "error")
    end
  end
  vim.cmd.doautocmd "ColorScheme"
  return success
end

--- Get an icon from the AstroNvim internal icons if it is available and return it
---@param kind string The kind of icon in astronvim.icons to retrieve
---@param padding? integer Padding to add to the end of the icon
---@param no_fallback? boolean Whether or not to disable fallback to text icon
---@return string icon
function M.get_icon(kind, padding, no_fallback)
  if not vim.g.icons_enabled and no_fallback then
    return ""
  end
  local icon_pack = vim.g.icons_enabled and "icons" or "text_icons"
  if not M[icon_pack] then
    M.icons = require "utils.static.icons"
    M.text_icons = require "utils.static.icons._icons_retro"
  end
  local icon = M[icon_pack] and M[icon_pack][kind]
  return icon and icon .. string.rep(" ", padding or 0) or ""
end

--- Serve a notification with a custom title
---@param msg string The notification body
---@param level? string The type of the notification (:help vim.log.levels)
---@param opts? table The nvim-notify options to use (:help notify-options)
function M.notify(msg, level, opts)
  vim.schedule(function()
    if not level then
      level = "info"
    end
    vim.notify(msg, vim.log.levels[level:upper()], M.extend_tbl({ title = "Custom" }, opts))
  end)
end

--- Serve a notification once with a custom title
---@param msg string The notification body
---@param level? string The type of the notification (:help vim.log.levels)
---@param opts? table The nvim-notify options to use (:help notify-options)
function M.notify_once(msg, level, opts)
  vim.schedule(function()
    if not level then
      level = "info"
    end
    vim.notify_once(msg, vim.log.levels[level:upper()], M.extend_tbl({ title = "Custom" }, opts))
  end)
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available # Whether the plugin is available
function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Resolve the options table for a given plugin with lazy
---@param plugin string The plugin to search for
---@return table opts # The plugin options
function M.plugin_opts(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  local lazy_plugin_avail, lazy_plugin = pcall(require, "lazy.core.plugin")
  local opts = {}
  if lazy_config_avail and lazy_plugin_avail then
    local spec = lazy_config.spec.plugins[plugin]
    if spec then
      opts = lazy_plugin.values(spec, "opts")
    end
  end
  return opts
end

function M.add_command(key, callback, opts)
  opts = vim.tbl_deep_extend("force", {
    cmd_opts = nil,
    add_custom = false,
  }, opts or {})

  assert(opts.cmd_opts or opts.add_custom, "must either provide cmd_opts or set add_custom")

  -- opts are defined, create user command
  if opts.cmd_opts then
    vim.api.nvim_create_user_command(key, callback, opts.cmd_opts)
  end

  -- create custom command
  if opts.add_custom then
    -- make sure this command takes:
    --  - no parameters
    --  - 0+ parameters
    assert(
      not opts.cmd_opts
        or not opts.cmd_opts.nargs
        or (opts.cmd_opts.nargs == 0)
        or (opts.cmd_opts.nargs == "*")
        or (opts.cmd_opts.nargs == "?"),
      "cannot add custom command which requires 1+ arguments"
    )

    -- add command header
    local header_regex = vim.regex "\\v\\[.*]"
    if not header_regex:match_str(key) then
      key = "[CMD] " .. key
    end
  end

  return key
end

---@type false|fun(bufname: string, filetype: string, buftype: string): string?,string?
local cached_icon_provider
--- Resolve the icon and color information for a given buffer
---@param bufnr integer the buffer number to resolve the icon and color of
---@return string? icon the icon string
---@return string? color the hex color of the icon
function M.icon_provider(bufnr)
  if not bufnr then
    bufnr = 0
  end
  local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype
  if cached_icon_provider then
    return cached_icon_provider(bufname, filetype, buftype)
  end
  if cached_icon_provider == false then
    return
  end

  local _, mini_icons = pcall(require, "mini.icons")
  -- mini.icons
  if _G.MiniIcons then
    cached_icon_provider = function(_bufname, _filetype)
      local icon, hl, is_default = mini_icons.get("file", _bufname)
      if is_default then
        icon, hl, is_default = mini_icons.get("filetype", _filetype)
      end
      local color = require("utils.hl").get_hlgroup(hl).fg
      if type(color) == "number" then
        color = string.format("#%06x", color)
      end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, bufname)
  end

  -- nvim-web-devicons
  local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
  if devicons_avail then
    cached_icon_provider = function(_bufname, _filetype, _buftype)
      local icon, color = devicons.get_icon_color(_bufname)
      if not color then
        icon, color = devicons.get_icon_color_by_filetype(_filetype, { default = _buftype == "" })
      end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, buftype)
  end

  -- fallback to no icon provider
  cached_icon_provider = false
end

return M
