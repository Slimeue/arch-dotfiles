-- Treesitter: syntax-aware highlighting, indentation and selection.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- classic `configs.setup` API; `main` is the in-progress rewrite
    lazy = false,      -- highlighting should be up before the first buffer draws
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Parsers compiled on first launch; more are fetched on demand.
        ensure_installed = {
          "bash", "c", "cmake", "cpp", "diff", "lua", "luadoc", "markdown", "markdown_inline",
          "python", "qmldir", "qmljs", "query", "regex", "toml", "vim", "vimdoc", "yaml", "json",
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection    = "<C-space>",
            node_incremental  = "<C-space>",
            node_decremental  = "<BS>",
            scope_incremental = false,
          },
        },
      })
    end,
  },
}
