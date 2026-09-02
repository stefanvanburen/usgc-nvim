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
  -- Gutter
  gutter_fg = p.fl_red,
  gutter_highlight = p.white,
  -- Upstream ships a terminal theme for this scheme alone,
  -- themes/iterm/USGC-RETICLE-IT.itermcolors, stored in Display P3 and
  -- converted to sRGB here. It is independent of the standard palette above.
  terminal = {
    [0] = '#262626',
    [1] = '#E00000',
    [2] = '#FFC200',
    [3] = '#FFC200',
    [4] = '#723DF9',
    [5] = '#FF208F',
    [6] = '#0079FF',
    [7] = '#FFFFFF',
    [8] = '#494747',
    [9] = '#E00000',
    [10] = '#F4BA00',
    [11] = '#FFC200',
    [12] = '#FF7321',
    [13] = '#FF208F',
    [14] = '#0078FF',
    [15] = '#FEFEFF',
  },
}

local M = {}

function M.apply()
  usgc.apply('usgc-reticle', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
