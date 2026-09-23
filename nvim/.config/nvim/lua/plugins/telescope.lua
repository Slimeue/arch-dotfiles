-- Telescope: fuzzy finder over files, grep results, buffers and help.
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter -- much faster on large result sets. Needs make + cc.
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Grep (live)" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",     desc = "Keymaps" },
    },
    config = function()
      local telescope = require("telescope")
      local actions   = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close, -- close straight from insert mode
            },
          },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      pcall(telescope.load_extension, "fzf")
    end,
  },
}
