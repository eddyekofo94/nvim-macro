return {
  "echasnovski/mini.visits",
  version = "*",
  lazy = false,
  config = function()
    local visits = require "mini.visits"
    visits.setup()

    -- Create and select
    local map_vis = function(keys, call, desc)
      local rhs = "<Cmd>lua MiniVisits." .. call .. "<CR>"
      vim.keymap.set("n", "<Leader>" .. keys, rhs, { desc = desc })
    end

    map_vis("vac", 'add_label("core")', "Add to core")
    map_vis("vV", 'remove_label("core")', "Remove from core")
    map_vis("vc", 'select_path("", { filter = "core" })', "Select core (all)")
    map_vis("vC", 'select_path(nil, { filter = "core" })', "Select core (cwd)")

    -- Iterate based on recency
    local map_iterate_core = function(lhs, direction, desc)
      local opts = { filter = "core", sort = visits.sort_latest, wrap = true }
      local rhs = function()
        MiniVisits.iterate_paths(direction, vim.fn.getcwd(), opts)
      end
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map_iterate_core("[{", "last", "Core label (earliest)")
    map_iterate_core("<Tab>", "forward", "Core label (earlier)")
    map_iterate_core("<S-Tab>", "backward", "Core label (later)")
    map_iterate_core("]}", "first", "Core label (latest)")

    local branch = vim.fn.system "git rev-parse --abbrev-ref HEAD"
    if vim.v.shell_error ~= 0 then
      return nil
    end
    branch = vim.trim(branch)
    local map_branch = function(keys, action, desc)
      local rhs = function()
        visits[action](branch)
      end
      vim.keymap.set("n", "<Leader>" .. keys, rhs, { desc = desc })
    end

    map_branch("vab", "add_label", "Add branch label")
    map_branch("vB", "remove_label", "Remove branch label")
    map_vis("vlb", "select_path(nil, { filter = '" .. branch .. "'})", "Remove branch label")
  end,
}
