return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true, -- show filtered items (dimmed) instead of hiding them
          hide_dotfiles = false, -- e.g. .env.local, .gitignore
          hide_gitignored = false,
          hide_by_name = { "node_modules", ".git" }, -- still toggle with H
        },
      },
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
      { "<leader>o", "<cmd>Neotree focus<cr>",  desc = "Focus explorer" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal file in explorer" },
    },
  },
  {
    "Crysthamus/nvim-file-operations",
    -- branch = "compat" -- if you are on Neovim <= 0.10
    dependencies = {
      "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require("nvim-file-operations").setup()
    end,
  },
  {
    "s1n7ax/nvim-window-picker",
    version = "2.*",
    config = function()
      require("window-picker").setup({
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal", "quickfix" },
          },
        },
      })
    end,
  },
}
