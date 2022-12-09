local fallback_tbl_t = {
  __index = function(tbl, _)
    return tbl.default
  end
}

function fallback_tbl_t:new(init_tbl)
  return setmetatable(init_tbl or {}, self)
end

local patterns = {
  ['<Tab>'] = fallback_tbl_t:new({
    markdown = {
      jumpable = [[\s*\()\|]\|}\|"\|'\|`\|\$\|\*\|,\|;\)]],
      jump_pos = [[)\|]\|}\|"\|'\|`\|\$\|\*\|,\|;]],
    },
    tex = {
      jumpable = [[\s*\()\|]\|}\|"\|'\|`\|\$\|,\|;\)]],
      jump_pos = [[)\|]\|}\|"\|'\|`\|\$\|,\|;]],
    },
    c = {
      jumpable = [[\s*\()\|]\|}\|"\|'\|`\|\*\/\|,\|;\)]],
      jump_pos = [[)\|]\|}\|"\|'\|`\|\/\|,\|;]],
    },
    cpp = {
      jumpable = [[\s*\()\|]\|}\|"\|'\|`\|\*\/\|,\|;\)]],
      jump_pos = [[)\|]\|}\|"\|'\|`\|\/\|,\|;]],
    },
    default = {
      jumpable = [[\s*\()\|]\|}\|"\|'\|`\|,\|;\)]],
      jump_pos = [[)\|]\|}\|"\|'\|`\|,\|;]],
    },
  }),

  ['<S-Tab>'] = fallback_tbl_t:new({
    markdown = {
      catch_content = [[\s*\()\|]\|}\|"\|'\|`\|\$\|\*\|,\|;\)\s*\zs\S\+\ze]],
      if_no_content = [[\s*\()\|]\|}\|"\|'\|`\|\$\|\*\|,\|;\)\zs\s*\ze]],
    },
    tex = {
      catch_content = [[\s*\()\|]\|}\|"\|'\|`\|\$\|,\|;\)\s*\zs\S\+\ze]],
      if_no_content = [[\s*\()\|]\|}\|"\|'\|`\|\$\|,\|;\)\zs\s*\ze]],
    },
    c = {
      catch_content = [[\s*\()\|]\|}\|"\|'\|`\|\/\*\|,\|;\)\s*\zs\S\+\ze]],
      if_no_content = [[\s*\()\|]\|}\|"\|'\|`\|\/\*\|,\|;\)\zs\s*\ze]],
    },
    cpp = {
      catch_content = [[\s*\()\|]\|}\|"\|'\|`\|\/\*\|,\|;\)\s*\zs\S\+\ze]],
      if_no_content = [[\s*\()\|]\|}\|"\|'\|`\|\/\*\|,\|;\)\zs\s*\ze]],
    },
    default = {
      catch_content = [[\s*\()\|]\|}\|"\|'\|`\|,\|;\)\s*\zs\S\+\ze]],
      if_no_content = [[\s*\()\|]\|}\|"\|'\|`\|,\|;\)\zs\s*\ze]],
    },
  }),
}

local get_jump_pos = {
  ['<Tab>'] = function()
    if vim.fn.mode() ~= 'i' then return false end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local trailing = vim.api.nvim_get_current_line():sub(cursor_pos[2] + 1, -1)
    local leading = vim.api.nvim_get_current_line():sub(1, cursor_pos[2])

    local jumpable = vim.fn.match(trailing, patterns['<Tab>'][vim.bo.ft].jumpable) == 0
      and vim.fn.match(leading, [[\S]]) ~= -1
    local jump_pos = vim.fn.match(trailing, patterns['<Tab>'][vim.bo.ft].jump_pos)

    if jumpable then
      return { cursor_pos[1], cursor_pos[2] + jump_pos + 1 }
    end

    return false
  end,

  ['<S-Tab>'] = function()
    if vim.fn.mode() ~= 'i' then return false end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local leading = vim.api.nvim_get_current_line():sub(1, cursor_pos[2]):reverse()

    local jump_pos = vim.fn.match(leading, patterns['<S-Tab>'][vim.bo.ft].catch_content)
    if jump_pos == -1 then
      jump_pos = vim.fn.match(leading, patterns['<S-Tab>'][vim.bo.ft].if_no_content)
    end

    if jump_pos ~= -1 then
      return { cursor_pos[1], cursor_pos[2] - jump_pos }
    end

    return false
  end
}

local function do_key(key)
  local pos = get_jump_pos[key]()
  if pos then
    vim.api.nvim_win_set_cursor(0, pos)
  else
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key, true, true, true), 'nt', false)
  end
end

return {
  do_key = do_key,
}
