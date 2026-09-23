-- Claude Code: runs Neovim as an IDE server so `claude` can see the active
-- buffer and the visual selection, same as the official VS Code extension.
-- Launch with <leader>ac, or attach an already-running session with /ide.
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" }, -- nicer terminal split; falls back to native
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
    },
    keys = {
      { "<leader>a",  nil,                                 desc = "Claude" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",               desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",          desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",      desc = "Resume session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",    desc = "Continue last session" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",          desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
      -- Accept or reject a diff Claude opens in the editor.
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>",     desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",       desc = "Reject diff" },
    },
    opts = {
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
      },
    },
  },
}
