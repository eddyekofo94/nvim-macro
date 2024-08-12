-- Declare the module
local telescope_pickers = {}
local sep = "/"

-- Store Utilities we'll use frequently
local telescope_utils = require "telescope.utils"
local telescope_make_entry_module = require "telescope.make_entry"
local fileTypeIconWidth = 2
local tailPathWidth = 15
local parentPathWidth = 40
local telescope_entry_display_module = require "telescope.pickers.entry_display"

-- Gets the File Path and its Tail (the file name) as a Tuple
function telescope_pickers.get_path_and_tail(file_name, len)
  -- Get the Tail
  local buffer_name_tail = telescope_utils.path_tail(file_name)

  -- Now remove the tail from the Full Path
  local path_without_tail = require("plenary.strings").truncate(file_name, #file_name - #buffer_name_tail, "")

  -- Apply truncation and other pertaining modifications to the path according to Telescope path rules
  local display = { "truncate" }
  if len and (#path_without_tail > len) then
    display = { shorten = { len = 1, exclude = { 1, -2, -1 } } }
  end
  -- display = len and { shorten = { len = 1, exclude = { 1, -1 } } } or { "shorten" }

  local path_to_display = telescope_utils.transform_path({
    path_display = display,
  }, path_without_tail)

  local parent = path_to_display == "" and "." or path_to_display
  -- Return as Tuple
  return buffer_name_tail, parent .. sep
end

function telescope_pickers.pretty_files_picker(builtin, opts)
  if opts ~= nil and type(opts) ~= "table" then
    print "Options must be a table."
    return
  end

  local options = opts or {}
  local original_entry_maker = telescope_make_entry_module.gen_from_file(options)

  options.entry_maker = function(line)
    local originalEntryTable = original_entry_maker(line)

    local displayer = telescope_entry_display_module.create {
      separator = " ",
      items = {
        { width = fileTypeIconWidth },
        { width = nil },
        { width = nil },
        { remaining = true },
      },
    }

    originalEntryTable.display = function(entry)
      local tail, path = telescope_pickers.get_path_and_tail(entry.filename)
      local tail_for_display = tail .. " "
      local icon, icon_hl = telescope_utils.get_devicons(tail)

      return displayer {
        { icon, icon_hl },
        tail_for_display,
        { path, "TelescopeResultsComment" },
      }
    end

    return originalEntryTable
  end

  require("telescope.builtin")[builtin](opts)
end

function telescope_pickers.pretty_buffers_picker(localOptions)
  if localOptions ~= nil and type(localOptions) ~= "table" then
    print "Options must be a table."
    return
  end

  local options = localOptions or {}

  local originalEntryMaker = telescope_make_entry_module.gen_from_buffer(options)

  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)

    local displayer = telescope_entry_display_module.create {
      separator = " ",
      items = {
        { width = fileTypeIconWidth },
        { width = nil },
        { width = nil },
        { remaining = true },
      },
    }

    originalEntryTable.display = function(entry)
      local tail, path = telescope_pickers.get_path_and_tail(entry.filename)
      local tailForDisplay = tail
      local icon, iconHighlight = telescope_utils.get_devicons(tail)

      return displayer {
        { icon, iconHighlight },
        tailForDisplay .. ":" .. entry.lnum,
        { "(" .. entry.bufnr .. ")", "TelescopeResultsNumber" },
        { path, "TelescopeResultsComment" },
      }
    end

    return originalEntryTable
  end

  require("telescope.builtin").buffers(options)
end

function telescope_pickers.longPath(gen)
  local options = {}

  local originalEntryMaker = gen(options)

  options.entry_maker = function(line)
    local originalEntryTable = originalEntryMaker(line)
    local parent = parentPathWidth
    local limit = vim.fn.winwidth(0) / 3
    local displayer = telescope_entry_display_module.create {
      separator = "│",
      items = {
        { width = tailPathWidth + fileTypeIconWidth + 1 },
        { width = parent < limit and parent or limit },
        { width = 6 },
        { remaining = true },
      },
    }

    originalEntryTable.display = function(entry)
      local tail, path = telescope_pickers.get_path_and_tail(entry.filename, parentPathWidth)
      local icon, iconHighlight = telescope_utils.get_devicons(tail)
      return displayer {
        { icon .. " " .. tail, iconHighlight },
        { path, "NonText" },
        { entry.lnum .. ":" .. entry.col, "NonText" },
        entry.text,
      }
    end

    return originalEntryTable
  end

  return options
end

local gen_from_quickfix = telescope_make_entry_module.gen_from_quickfix
function telescope_pickers.lsp_incoming_calls()
  require("telescope.builtin").lsp_incoming_calls(telescope_pickers.longPath(gen_from_quickfix))
end
function telescope_pickers.lsp_outgoing_calls()
  require("telescope.builtin").lsp_outgoing_calls(telescope_pickers.longPath(gen_from_quickfix))
end
function telescope_pickers.lsp_references()
  require("telescope.builtin").lsp_references(telescope_pickers.longPath(gen_from_quickfix))
end
function telescope_pickers.lsp_implementations()
  require("telescope.builtin").lsp_implementations(telescope_pickers.longPath(gen_from_quickfix))
end

local gen_from_vimgrep = telescope_make_entry_module.gen_from_vimgrep
function telescope_pickers.live_grep(opts)
  require("telescope.builtin").live_grep(telescope_pickers.longPath(gen_from_vimgrep), opts)
end
function telescope_pickers.grep_string(opts)
  require("telescope.builtin").grep_string(telescope_pickers.longPath(gen_from_vimgrep), opts)
end

return telescope_pickers
