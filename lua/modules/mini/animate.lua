return {
  "echasnovski/mini.animate",
  keys = {
    {
      "<leader>aa",
      function()
        vim.g.minianimate_disable = not vim.g.minianimate_disable
        if vim.g.minianimate_disable then
          vim.notify("Disabled animation", vim.log.levels.INFO)
        else
          vim.notify("Enabled animation", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle animate",
    },
    { "gg" },
    { "G" },
    { "H" },
    { "L" },
    { "M" },
    { "<C-D>" },
    { "<C-U>" },
    { "<C-F>" },
    { "<C-P>" },
  },
  opts = function()
    -- don't use animate when scrolling with the mouse
    local mouse_scrolled = false
    for _, scroll in ipairs { "Up", "Down" } do
      local key = "<ScrollWheel" .. scroll .. ">"
      vim.keymap.set({ "", "i" }, key, function()
        mouse_scrolled = true
        return key
      end, { expr = true })
    end

    local animate = require "mini.animate"
    return {
      cursor = {
        timing = animate.gen_timing.linear { duration = 100, unit = "total" },
      },
      close = { enable = false },
      resize = {
        enable = false,
        timing = animate.gen_timing.linear { duration = 100, unit = "total" },
      },
      scroll = {
        timing = animate.gen_timing.linear { duration = 150, unit = "total" },
        subscroll = animate.gen_subscroll.equal {
          predicate = function(total_scroll)
            if mouse_scrolled then
              mouse_scrolled = false
              return false
            end
            return total_scroll > 1
          end,
        },
      },
    }
  end,
  config = function(_, opts)
    if opts then
      require("mini.animate").setup(opts)
      -- vim.g.minianimate_disable = not cond.animate
    end
  end,
}
