---Add attributes to a snippet group
---@param attr table
---@param snip_group table
---@return table
local function add_attr(attr, snip_group)
  for _, snip in ipairs(snip_group) do
    for attr_key, attr_val in pairs(attr) do
      snip[attr_key] = attr_val
    end
  end
  return snip_group
end

---Returns the depth of the current indent given the indent of the current line
---@param indent number|string
local function get_indent_depth(indent)
  if type(indent) == 'string' then
    indent = #indent:match('^%s*'):gsub('\t', string.rep(' ', vim.bo.ts))
  end
  if indent <= 0 then
    return 0
  end
  local sts
  if vim.bo.sts > 0 then
    sts = vim.bo.sts
  elseif vim.bo.sw > 0 then
    sts = vim.bo.sw
  else
    sts = vim.bo.ts
  end
  return math.floor(indent / sts)
end

return {
  add_attr = add_attr,
  get_indent_depth = get_indent_depth,
}
