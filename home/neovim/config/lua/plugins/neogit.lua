local neogit = require("neogit")

neogit.setup {
  disable_signs = false,
  disable_context_highlighting = false,
  disable_commit_confirmation = true,
  auto_refresh = true,
  disable_builtin_notifications = false,
  commit_popup = {
      kind = "split",
  },
  -- customize displayed signs
  signs = {
    -- { CLOSED, OPENED }
    section = { ">", "v" },
    item = { ">", "v" },
    hunk = { "", "" },
  },
  integrations = {
    diffview = true
  },
  -- override/add mappings
  mappings = {
    -- modify status buffer mappings
    status = {
      ["l"] = "PullPopup",
      ["p"] = "PushPopup",
      ["t"] = "StashPopup",
      ["g"] = "LogPopup",
      ["s"] = "",
      ["S"] = "",
      ["e"] = "Stage",
      ["E"] = "StageUnstaged",
    }
  }
}
