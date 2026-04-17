-- USGC HIGHK - White scheme
-- High dielectric constant
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.white,
  fg = p.black,
  caret = p.fl_blue,
  accent = p.fl_red,
  -- Visual selection and search
  selection_bg = p.fl_cyan,
  selection_fg = p.black,
  -- Cursor line (subtle)
  cursorline_bg = p.gray,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.gray,
  popup_sel_bg = p.fl_red,
  popup_sel_fg = p.white,
  -- Gutter
  gutter_fg = p.fl_red,
  gutter_highlight = p.black,
}

local M = {}

function M.apply()
  usgc.apply('usgc-highk', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
