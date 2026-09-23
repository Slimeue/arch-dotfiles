-- Make Neovim's backgrounds transparent so the terminal shows through.
-- Requires a translucent terminal -- kitty has background_opacity 0.5 set.
--
-- Colorschemes reset highlights when they load, so this re-applies on every
-- ColorScheme event rather than running once at startup.

local M = {}

-- Groups whose background should be cleared.
local groups = {
  -- core editor
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
  "SignColumn", "LineNr", "CursorLineNr", "EndOfBuffer", "NonText",
  "FoldColumn", "Folded", "MsgArea", "VertSplit", "WinSeparator",
  -- statusline / tabline
  "StatusLine", "StatusLineNC", "TabLine", "TabLineFill", "TabLineSel",
  -- popups
  "Pmenu", "PmenuSbar", "PmenuThumb",
  -- telescope
  "TelescopeNormal", "TelescopeBorder", "TelescopeTitle",
  "TelescopePromptNormal", "TelescopePromptBorder", "TelescopePromptTitle",
  "TelescopeResultsNormal", "TelescopeResultsBorder",
  "TelescopePreviewNormal", "TelescopePreviewBorder",
  -- lazy.nvim UI
  "LazyNormal",
}

function M.apply()
  for _, g in ipairs(groups) do
    -- Keep fg/attrs the colorscheme chose; only drop the background.
    vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "none" })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("Transparency", { clear = true }),
    callback = M.apply,
  })
  M.apply() -- current colorscheme, already loaded
end

return M
