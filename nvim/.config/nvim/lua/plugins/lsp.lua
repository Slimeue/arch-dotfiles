-- LSP: nvim-lspconfig ships the per-server launch recipes; Neovim's built-in
-- client (vim.lsp) does the talking. Servers themselves are installed by pacman.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- blink.cmp advertises extra client capabilities (snippets, resolve,
      -- label details). It does not register them itself, so apply them to
      -- every server via the "*" wildcard config.
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
      end

      -- QML / Quickshell. lspconfig defaults to the binary name `qmlls`, but
      -- qt6-declarative installs it as `qmlls6` (plain `qmlls` lives in
      -- /usr/lib/qt6/bin, which is not on PATH).
      vim.lsp.config("qmlls", { cmd = { "qmlls6" } })
      vim.lsp.enable("qmlls")

      -- C / C++. Reads compile_commands.json (or a .clangd file) from the
      -- project root for include paths and flags; formats via clang-format.
      vim.lsp.enable("clangd")

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      -- Synchronous on purpose: an async format would race the write and the
      -- edits would land after the file is already on disk.
      vim.api.nvim_create_autocmd("BufWritePre", {
        desc = "Format on save",
        callback = function(ev)
          -- Skip when no attached server can format (server still starting,
          -- or a buffer with no LSP at all) -- otherwise vim.lsp.buf.format
          -- warns "no matching language servers" on every such write.
          local clients = vim.lsp.get_clients({
            bufnr = ev.buf,
            method = "textDocument/formatting",
          })
          if #clients == 0 then return end
          vim.lsp.buf.format({ bufnr = ev.buf, timeout_ms = 2000 })
        end,
      })

      -- Neovim 0.11+ already maps K, grn, gra, grr, gri and gO on attach.
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Extra LSP keymaps",
        callback = function(ev)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("<leader>e", vim.diagnostic.open_float, "Line diagnostics")
        end,
      })
    end,
  },
}
