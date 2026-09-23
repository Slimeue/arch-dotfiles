-- Renders hex colour codes in their own colour, so the palette in Style.qml
-- and Theme.qml reads as swatches instead of digits.
return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },
      user_default_options = {
        names = false, -- don't tint bare words like "red" or "tan"
        css = true,    -- rgb()/hsl() as well as #rrggbb
        mode = "background",
      },
    },
  },
}
