-- USGC HIGHK - White scheme
-- High dielectric constant
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.white,
  fg = p.black,
  caret = p.fl_blue,
  accent = p.fl_red,
  selection_bg = p.fl_green,
  selection_fg = p.black,
  line_highlight = p.fl_green,
  gutter_fg = p.fl_red,
  gutter_highlight = p.black,
}

local M = {}

function M.apply()
  usgc.apply('usgc-highk', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
