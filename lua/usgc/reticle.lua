-- USGC RETICLE - Dark scheme
-- Photomask for lithography
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.green,
  caret = p.white,
  accent = p.fl_red,
  selection_bg = p.white,
  selection_fg = p.fl_blue,
  line_highlight = p.fl_blue,
  gutter_fg = p.fl_red,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-reticle', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
