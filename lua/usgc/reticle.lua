-- USGC RETICLE - Dark scheme
-- Photomask for lithography
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.green,
  caret = p.white,
  accent = p.fl_red,
  -- Visual selection and search
  selection_bg = p.maroon,
  selection_fg = p.fl_red,
  -- Cursor line (subtle)
  cursorline_bg = p.blue,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.maroon,
  popup_sel_bg = p.green,
  popup_sel_fg = p.black,
  -- Gutter
  gutter_fg = p.fl_red,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-reticle', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
