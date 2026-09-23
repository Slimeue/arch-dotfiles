-- Completion engine. Rust fuzzy matcher, own floating menu (does NOT use the
-- built-in popup) — so vim.lsp.completion must stay off, or the two fight.
return {
  {
    "saghen/blink.cmp",
    version = "1.*", -- tagged releases ship a prebuilt binary; no cargo needed
    opts = {
      -- <CR> accept, <C-space> open/docs, <C-n>/<C-p> or arrows to cycle,
      -- <C-e> dismiss, <C-k> signature help.
      -- The "default" preset leaves <CR> unmapped, so Enter just made a
      -- newline while the menu was open; "enter" binds it to accept.
      keymap = { preset = "enter" },

      appearance = { nerd_font_variant = "mono" },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
        menu = { border = "rounded" },
      },

      signature = { enabled = true, window = { border = "rounded" } },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
