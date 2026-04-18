-- USGC RETICLE - Dark scheme
-- Photomask for lithography
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.green,
  caret = p.white,
  accent = p.fl_red,
  -- Visual selection and search (original uses white)
  selection_bg = p.white,
  selection_fg = p.fl_blue,
  -- Cursor line (original uses fl_blue)
  cursorline_bg = p.fl_blue,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.maroon,
  popup_sel_bg = p.green,
  popup_sel_fg = p.black,
  -- LSP references / folds / context
  reference_bg = p.fl_blue,
  fold_bg = p.fl_blue,
  context_bg = p.fl_blue,
  -- Gutter
  gutter_fg = p.fl_red,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-reticle', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
