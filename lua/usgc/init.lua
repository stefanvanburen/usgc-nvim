-- USGC Color Schemes for Neovim
-- Ported from https://github.com/usgraphics/usgc-themes
-- All credit to U.S. Graphics Company
--
-- Standard USGC color palette
local M = {}

M.palette = {
  black = '#000000',
  white = '#FFFFFF',
  fl_red = '#FF0000',
  fl_green = '#00FF00',
  fl_blue = '#0000FF',
  fl_cyan = '#00FFFF',
  fl_magenta = '#FF00FF',
  fl_yellow = '#FFFF00',
  fl_orange = '#FF6600',
  maroon = '#660000',
  green = '#00A645',
  blue = '#000066',
  cyan = '#006666',
  magenta = '#660066',
  yellow = '#FFBF00',
  olive = '#666600',
  gray = '#999999',
}

-- Apply a colorscheme
-- @param name string
-- @param groups table<string, table>
-- @param terminal table<number, string>
function M.apply(name, groups, terminal)
  vim.cmd('highlight clear')
  vim.g.colors_name = name

  for group_name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group_name, spec)
  end

  for i = 0, 15 do
    vim.g['terminal_color_' .. i] = terminal[i]
  end
end

-- Split a "#RRGGBB" string into its channels.
local function channels(hex)
  local n = tonumber(hex:sub(2), 16)
  return math.floor(n / 0x10000), math.floor(n / 0x100) % 0x100, n % 0x100
end

-- Mix `color` into `onto`; `alpha` is the share taken from `color`.
local function mix(color, onto, alpha)
  local cr, cg, cb = channels(color)
  local orr, og, ob = channels(onto)
  return string.format(
    '#%02X%02X%02X',
    math.floor(cr * alpha + orr * (1 - alpha) + 0.5),
    math.floor(cg * alpha + og * (1 - alpha) + 0.5),
    math.floor(cb * alpha + ob * (1 - alpha) + 0.5)
  )
end

-- Every variant's background is either black or white, so this only has to
-- pick a side.
local function is_light(hex)
  local r, g, b = channels(hex)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b > 128
end

-- Generate highlight groups for a theme variant
-- @param opts table with:
--   bg, fg, accent, caret
--   selection_bg, selection_fg (for Visual, Search)
--   cursorline_bg (for CursorLine - subtle)
--   popup_bg, popup_sel_bg, popup_sel_fg (for Pmenu, floats)
--   gutter_fg, gutter_highlight
function M.make_groups(opts)
  local p = M.palette

  -- Diff backgrounds are mixed against the theme's own background instead of
  -- taken from the palette, because a plugin may pair them with a foreground
  -- the theme never chose for them: diffs.nvim derives its own backgrounds
  -- from DiffAdd's and DiffDelete's and leaves the buffer's text on top, which
  -- put Added's #00A645 over a background made from that same #00A645, at
  -- 1.0:1.
  --
  -- The three line-level mixes are tuned to one luminance, that of the
  -- palette's maroon -- itself fl_red mixed 40% into black -- so a foreground
  -- reads the same over all of them, and holds 4.2:1 against the dimmest
  -- foreground of any variant. DiffText is brighter on purpose, to separate
  -- the changed text inside a changed line, and holds 3:1 there.
  local function tint(color, alpha)
    return mix(color, opts.bg, alpha)
  end

  -- Text that sits on cursorline_bg. It is a fluorescent primary in every
  -- variant, so the theme's own foreground is not guaranteed to read on it:
  -- usgc-reticle's #00A645 came out at 2.68:1 there and usgc-highk's gray
  -- folds at 2.08:1. Black or white against the band clears 8.59:1 at worst,
  -- and leaves the band itself alone -- it is the color the scheme is known
  -- for. Groups that carry arbitrary syntax on it rather than the theme's own
  -- foreground -- CursorLine, TreesitterContext, LspReferenceText,
  -- QuickFixLine -- cannot be fixed this way and keep what they had.
  local cursorline_fg = is_light(opts.cursorline_bg) and p.black or p.white

  -- Foregrounds run the other way. A palette color bright enough for a black
  -- background is often too pale for a white one -- #00FFFF reaches 1.25:1
  -- there -- so on a light theme each one is taken 40% into black, the same
  -- mix that produced the palette's own dark tones.
  local light = is_light(opts.bg)
  local function ink(color)
    return light and mix(color, p.black, 0.4) or color
  end

  return {
    -- Treesitter
    ['@attribute'] = { link = 'Macro' },
    ['@attribute.builtin'] = { link = 'Special' },
    ['@boolean'] = { link = 'Boolean' },
    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'SpecialChar' },
    ['@comment'] = { link = 'Comment' },
    ['@comment.error'] = { link = 'DiagnosticError' },
    ['@comment.note'] = { link = 'DiagnosticInfo' },
    ['@comment.todo'] = { link = 'Todo' },
    ['@comment.warning'] = { link = 'DiagnosticWarn' },
    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { link = 'Special' },
    ['@constructor'] = { link = 'Special' },
    ['@diff'] = {},
    ['@diff.delta'] = { link = 'Changed' },
    ['@diff.minus'] = { link = 'Removed' },
    ['@diff.plus'] = { link = 'Added' },
    ['@function'] = { link = 'Function' },
    ['@function.builtin'] = { link = 'Special' },
    ['@keyword'] = { link = 'Keyword' },
    ['@label'] = { link = 'Label' },
    ['@lsp'] = {},
    ['@lsp.mod.deprecated'] = { link = 'DiagnosticDeprecated' },
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.comment'] = { link = '@comment' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.event'] = { link = '@type' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.keyword'] = { link = '@keyword' },
    ['@lsp.type.macro'] = { link = '@constant.macro' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.modifier'] = { link = '@type.qualifier' },
    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.number'] = { link = '@number' },
    ['@lsp.type.operator'] = { link = '@operator' },
    ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.regexp'] = { link = '@string.regexp' },
    ['@lsp.type.string'] = { link = '@string' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { link = '@type.definition' },
    ['@lsp.type.variable'] = { link = '@variable' },
    ['@markup'] = { link = 'Special' },
    ['@markup.heading'] = { link = 'Title' },
    ['@markup.italic'] = { italic = true },
    ['@markup.link'] = { link = 'Underlined' },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.strong'] = { bold = true },
    ['@markup.underline'] = { underline = true },
    ['@module'] = { link = 'Structure' },
    ['@module.builtin'] = { link = 'Special' },
    ['@number'] = { link = 'Number' },
    ['@number.float'] = { link = 'Float' },
    ['@operator'] = { link = 'Operator' },
    ['@property'] = { link = 'Identifier' },
    ['@punctuation'] = { link = 'Delimiter' },
    ['@punctuation.special'] = { link = 'Special' },
    ['@spell'] = {},
    ['@string'] = { link = 'String' },
    ['@string.escape'] = { link = '@string.special' },
    ['@string.regexp'] = { link = '@string.special' },
    ['@string.special'] = { link = 'SpecialChar' },
    ['@string.special.url'] = { link = 'Underlined' },
    ['@tag'] = { link = 'Tag' },
    ['@tag.builtin'] = { link = 'Special' },
    ['@text'] = {},
    ['@text.diff.add'] = { link = 'DiffAdd' },
    ['@text.diff.delete'] = { link = 'DiffDelete' },
    ['@text.note'] = { link = 'Todo' },
    ['@text.todo'] = { link = 'Todo' },
    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { link = 'Special' },
    ['@variable'] = { fg = opts.fg },
    ['@variable.builtin'] = { link = 'Special' },
    ['@variable.parameter.builtin'] = { link = 'Special' },

    -- Standard highlight groups
    Bold = { bold = true },
    Boolean = { link = 'Constant' },
    Character = { link = 'Constant' },
    ColorColumn = { bg = opts.cursorline_bg },
    Comment = { fg = p.gray },
    ComplMatchIns = {},
    Conceal = {},
    Conditional = { link = 'Statement' },
    Constant = { fg = opts.fg },
    Cursor = { fg = opts.bg, bg = opts.caret },
    CursorColumn = { bg = opts.cursorline_bg },
    CursorIM = {},
    CursorLine = { bg = opts.cursorline_bg },
    CursorLineFold = { link = 'FoldColumn' },
    CursorLineNr = { fg = opts.gutter_highlight, bg = opts.cursorline_bg },
    CursorLineSign = { link = 'SignColumn' },
    Debug = { link = 'Special' },
    Define = { link = 'PreProc' },
    Delimiter = { fg = opts.fg },
    DiagnosticError = { fg = p.fl_red },
    DiagnosticFloatingError = { link = 'DiagnosticError' },
    DiagnosticFloatingHint = { link = 'DiagnosticHint' },
    DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
    DiagnosticFloatingOk = { link = 'DiagnosticOk' },
    DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
    DiagnosticHint = { fg = p.gray },
    -- Not fl_blue: #0000FF sits at 2.44:1 against the four black backgrounds,
    -- and the palette holds no lighter blue. ink() turns this into the
    -- palette's own #006666 CYAN on a light background.
    DiagnosticInfo = { fg = ink(p.fl_cyan) },
    DiagnosticOk = { fg = p.green },
    DiagnosticSignError = { link = 'DiagnosticError' },
    DiagnosticSignHint = { link = 'DiagnosticHint' },
    DiagnosticSignInfo = { link = 'DiagnosticInfo' },
    DiagnosticSignOk = { link = 'DiagnosticOk' },
    DiagnosticSignWarn = { link = 'DiagnosticWarn' },
    DiagnosticUnnecessary = { link = 'Comment' },
    DiagnosticVirtualLinesError = { link = 'DiagnosticError' },
    DiagnosticVirtualLinesHint = { link = 'DiagnosticHint' },
    DiagnosticVirtualLinesInfo = { link = 'DiagnosticInfo' },
    DiagnosticVirtualLinesOk = { link = 'DiagnosticOk' },
    DiagnosticVirtualLinesWarn = { link = 'DiagnosticWarn' },
    DiagnosticVirtualTextError = { link = 'DiagnosticError' },
    DiagnosticVirtualTextHint = { link = 'DiagnosticHint' },
    DiagnosticVirtualTextInfo = { link = 'DiagnosticInfo' },
    DiagnosticVirtualTextOk = { link = 'DiagnosticOk' },
    DiagnosticVirtualTextWarn = { link = 'DiagnosticWarn' },
    DiagnosticWarn = { fg = p.fl_orange },
    Added = { fg = ink(p.fl_green) },
    Changed = { fg = ink(p.fl_yellow) },
    Removed = { fg = ink(p.fl_red) },
    DiffAdd = { fg = opts.fg, bg = tint(p.fl_green, 0.22) },
    DiffChange = { fg = opts.fg, bg = tint(p.fl_yellow, 0.19) },
    DiffDelete = { fg = opts.fg, bg = tint(p.fl_red, 0.4) },
    DiffText = { fg = opts.fg, bg = tint(p.fl_yellow, 0.27), bold = true },
    Directory = { fg = opts.accent },
    EndOfBuffer = { link = 'NonText' },
    Error = { fg = opts.bg, bg = p.fl_red, bold = true },
    ErrorMsg = { fg = p.fl_red },
    Exception = { link = 'Statement' },
    Float = { link = 'Number' },
    FloatBorder = { fg = opts.accent, bg = opts.popup_bg },
    FloatFooter = { link = 'FloatTitle' },
    FloatTitle = { link = 'Title' },
    FoldColumn = { fg = p.gray },
    Folded = { fg = cursorline_fg, bg = opts.cursorline_bg },
    Function = { fg = opts.fg },
    Identifier = { fg = opts.fg },
    Ignore = { link = 'Normal' },
    IncSearch = { fg = opts.bg, bg = opts.accent, bold = true },
    Include = { link = 'PreProc' },
    Italic = { italic = true },
    Keyword = { link = 'Statement' },
    Label = { link = 'Statement' },
    LineNr = { fg = opts.gutter_fg },
    LineNrAbove = { link = 'LineNr' },
    LineNrBelow = { link = 'LineNr' },
    LspCodeLens = { link = 'NonText' },
    LspCodeLensSeparator = { link = 'LspCodeLens' },
    LspInlayHint = { link = 'NonText' },
    LspReferenceRead = { link = 'LspReferenceText' },
    LspReferenceTarget = { link = 'LspReferenceText' },
    LspReferenceText = { bg = opts.cursorline_bg },
    LspReferenceWrite = { link = 'LspReferenceText' },
    LspSignatureActiveParameter = { link = 'Visual' },
    Macro = { link = 'PreProc' },
    MatchParen = { fg = opts.accent, bg = opts.bg, bold = true },
    ModeMsg = { fg = opts.fg },
    MoreMsg = { fg = opts.fg },
    MsgArea = {},
    MsgSeparator = {},
    NonText = { fg = p.gray },
    Normal = { fg = opts.fg, bg = opts.bg },
    NormalFloat = { fg = opts.fg, bg = opts.popup_bg },
    NormalNC = {},
    Number = { link = 'Constant' },
    Operator = { fg = opts.fg },
    Pmenu = { fg = opts.fg, bg = opts.popup_bg },
    PmenuExtra = { link = 'Pmenu' },
    PmenuExtraSel = { link = 'PmenuSel' },
    PmenuKind = { link = 'Pmenu' },
    PmenuKindSel = { link = 'PmenuSel' },
    PmenuMatch = { fg = opts.accent, bold = true },
    PmenuMatchSel = { fg = opts.popup_sel_fg, bg = opts.popup_sel_bg, bold = true },
    PmenuSbar = { bg = opts.popup_bg },
    PmenuSel = { fg = opts.popup_sel_fg, bg = opts.popup_sel_bg, bold = true },
    PmenuThumb = { bg = opts.accent },
    PreCondit = { link = 'PreProc' },
    PreProc = { fg = opts.fg },
    Question = { fg = opts.fg },
    QuickFixLine = { bg = opts.cursorline_bg },
    Repeat = { link = 'Statement' },
    Search = { fg = opts.selection_fg, bg = opts.selection_bg, bold = true },
    SignColumn = { fg = opts.fg, bg = opts.bg },
    SnippetTabstop = { link = 'Visual' },
    Special = { fg = opts.accent },
    SpecialChar = { link = 'Special' },
    SpecialComment = { link = 'Special' },
    SpecialKey = { fg = p.gray },
    SpellBad = { sp = p.fl_red, undercurl = true },
    SpellCap = { sp = p.fl_blue, undercurl = true },
    SpellLocal = { sp = p.green, undercurl = true },
    SpellRare = { sp = p.fl_magenta, undercurl = true },
    Statement = { fg = opts.fg, bold = true },
    StatusLine = { fg = opts.bg, bg = opts.fg },
    StatusLineNC = { fg = cursorline_fg, bg = opts.cursorline_bg },
    StatusLineTerm = { link = 'StatusLine' },
    StatusLineTermNC = { link = 'StatusLineNC' },
    StorageClass = { link = 'Type' },
    String = { fg = opts.fg },
    Structure = { link = 'Type' },
    Substitute = { fg = opts.selection_fg, bg = opts.selection_bg },
    TabLine = { fg = cursorline_fg, bg = opts.cursorline_bg },
    TabLineFill = { bg = opts.bg },
    -- Not reversed: Neovim draws the window count inside the selected tab in
    -- Title, whose foreground is the theme's own, so a background of that same
    -- color made the count invisible in all five variants. The selected tab
    -- reads as the buffer does, and the unselected ones carry the band.
    TabLineSel = { fg = opts.fg, bg = opts.bg, bold = true },
    Tag = { link = 'Special' },
    TermCursor = { fg = opts.bg, bg = opts.caret },
    TermCursorNC = { fg = opts.bg, bg = p.gray },
    Title = { fg = opts.fg, bold = true },
    Todo = { fg = opts.accent, bold = true },
    Type = { fg = opts.fg },
    Typedef = { link = 'Type' },
    Underlined = { underline = true },
    VertSplit = { fg = p.gray },
    Visual = { fg = opts.selection_fg, bg = opts.selection_bg },
    WarningMsg = { fg = p.fl_orange },
    Whitespace = { link = 'NonText' },
    WildMenu = { fg = opts.popup_sel_fg, bg = opts.popup_sel_bg, bold = true },
    WinSeparator = { fg = p.gray },
    diffAdded = { link = 'Added' },
    diffChanged = { link = 'Changed' },
    diffRemoved = { link = 'Removed' },
    gitcommitOverflow = { link = 'WarningMsg' },

    -- mini.nvim
    MiniCompletionActiveParameter = { link = 'LspSignatureActiveParameter' },
    MiniDepsChangeAdded = { link = 'Added' },
    MiniDepsChangeRemoved = { link = 'Removed' },
    MiniDepsHint = { link = 'DiagnosticHint' },
    MiniDepsInfo = { link = 'DiagnosticInfo' },
    MiniDepsMsgBreaking = { link = 'DiagnosticWarn' },
    MiniDepsPlaceholder = { link = 'Comment' },
    MiniDepsTitle = { link = 'Title' },
    MiniDepsTitleError = { link = 'DiffDelete' },
    MiniDepsTitleSame = { link = 'DiffText' },
    MiniDepsTitleUpdate = { link = 'DiffAdd' },
    MiniTrailspace = { bg = p.fl_red },

    -- mini.pick
    MiniPickMatchCurrent = { link = 'PmenuSel' },
    -- Drawn over MiniPickMatchCurrent, so it carries its own background: as
    -- an accent foreground it vanished into that row in usgc-highk.
    MiniPickMatchRanges = { link = 'IncSearch' },
    MiniPickPreviewRegion = { link = 'Visual' },
    MiniPickPrompt = { link = 'Special' },

    -- mini.statusline
    MiniStatuslineDevinfo = { fg = cursorline_fg, bg = opts.cursorline_bg },
    MiniStatuslineFileinfo = { link = 'MiniStatuslineDevinfo' },
    MiniStatuslineFilename = { link = 'StatusLineNC' },
    MiniStatuslineInactive = { link = 'StatusLineNC' },
    MiniStatuslineModeCommand = { fg = p.black, bg = p.yellow, bold = true },
    MiniStatuslineModeInsert = { fg = p.black, bg = p.green, bold = true },
    MiniStatuslineModeNormal = { fg = opts.bg, bg = opts.fg, bold = true },
    MiniStatuslineModeOther = { fg = p.black, bg = p.gray, bold = true },
    MiniStatuslineModeReplace = { fg = p.white, bg = p.fl_red, bold = true },
    MiniStatuslineModeVisual = { fg = p.black, bg = p.fl_green, bold = true },

    -- mini.starter
    -- No MiniStarterCurrent: mini.starter draws the item prefix and the query
    -- over the current item, both in the accent color, and its own default
    -- leaves the current item unfilled for exactly that reason. Filling it
    -- with PmenuSel hid the prefix behind an accent-colored block in four of
    -- the five variants -- and completely in usgc-highk, where the accent and
    -- the selection are both #FF0000. The cursor marks the item instead.
    MiniStarterFooter = { link = 'Comment' },
    MiniStarterItemBullet = { link = 'Special' },
    MiniStarterItemPrefix = { link = 'Special' },
    MiniStarterSection = { link = 'Title' },
    MiniStarterQuery = { fg = opts.accent, bold = true },

    -- mini.jump / mini.jump2d
    MiniJump = { fg = opts.bg, bg = opts.accent, bold = true },
    MiniJump2dDim = { link = 'Comment' },
    MiniJump2dSpot = { fg = opts.bg, bg = opts.accent, bold = true },
    MiniJump2dSpotAhead = { fg = opts.bg, bg = opts.fg },
    MiniJump2dSpotUnique = { link = 'MiniJump2dSpot' },

    -- mini.hipatterns
    MiniHipatternsFixme = { fg = opts.bg, bg = p.fl_red, bold = true },
    MiniHipatternsHack = { fg = p.black, bg = p.fl_orange, bold = true },
    MiniHipatternsTodo = { fg = p.white, bg = p.fl_blue, bold = true },
    MiniHipatternsNote = { fg = p.black, bg = p.green, bold = true },

    -- mini.icons
    MiniIconsAzure = { fg = ink(p.fl_cyan) },
    MiniIconsBlue = { fg = ink(p.fl_blue) },
    MiniIconsCyan = { fg = ink(p.cyan) },
    MiniIconsGreen = { fg = ink(p.green) },
    MiniIconsGrey = { fg = ink(p.gray) },
    MiniIconsOrange = { fg = ink(p.fl_orange) },
    MiniIconsPurple = { fg = ink(p.fl_magenta) },
    MiniIconsRed = { fg = ink(p.fl_red) },
    MiniIconsYellow = { fg = ink(p.yellow) },

    -- mini.git
    MiniGitSignAdd = { link = 'Added' },
    MiniGitSignChange = { link = 'Changed' },
    MiniGitSignDelete = { link = 'Removed' },

    -- treesitter-context
    TreesitterContext = { bg = opts.cursorline_bg },
    TreesitterContextLineNumber = { fg = opts.gutter_fg, bg = opts.cursorline_bg },
    TreesitterContextSeparator = { fg = p.gray },

    -- mason.nvim
    MasonNormal = { link = 'NormalFloat' },
    MasonHeader = { fg = p.black, bg = opts.accent, bold = true },
    MasonHeaderSecondary = { fg = opts.bg, bg = opts.fg, bold = true },
    MasonHighlight = { fg = opts.accent },
    MasonHighlightBlock = { fg = p.black, bg = opts.accent },
    MasonHighlightBlockBold = { fg = p.black, bg = opts.accent, bold = true },
    MasonHighlightSecondary = { fg = opts.fg },
    MasonHighlightBlockSecondary = { fg = opts.bg, bg = opts.fg },
    MasonHighlightBlockBoldSecondary = { fg = opts.bg, bg = opts.fg, bold = true },
    MasonMuted = { fg = p.gray },
    MasonMutedBlock = { fg = p.black, bg = p.gray },
    MasonMutedBlockBold = { fg = p.black, bg = p.gray, bold = true },
    MasonError = { link = 'ErrorMsg' },
    MasonWarning = { link = 'WarningMsg' },
    MasonHeading = { bold = true },
  }
end

-- Apply the variant matching 'background', for the `usgc` colorscheme.
-- Override either variant with g:usgc_light or g:usgc_dark.
function M.variant()
  local light = vim.g.usgc_light or 'usgc-highk'
  local dark = vim.g.usgc_dark or 'usgc-polyimide'
  local name = vim.o.background == 'light' and light or dark

  -- Applied through the module rather than :colorscheme, because the variant's
  -- own 'background' setting resets highlighting when it runs nested inside
  -- this one.
  require('usgc.' .. name:gsub('^usgc%-', '')).apply()

  -- Take back the name the variant just set, so Neovim re-sources this
  -- colorscheme -- and so picks the other variant -- when 'background' changes.
  vim.g.colors_name = 'usgc'
end

-- Generate terminal colors for a theme
-- Themes set opts.terminal when the default does not suit them; the default
-- assumes a black background.
-- @param opts table, optionally with terminal table<number, string>
function M.make_terminal(opts)
  if opts.terminal then
    return opts.terminal
  end

  local p = M.palette
  -- Slots 4 and 12 are not fl_blue: #0000FF sits at 2.44:1 against black, and
  -- the standard palette holds no blue that clears 3:1 there. The violet is
  -- upstream's own terminal blue, from themes/iterm/USGC-RETICLE-IT.itermcolors.
  return {
    [0] = p.black,
    [1] = p.fl_red,
    [2] = p.green,
    [3] = p.yellow,
    [4] = '#723DF9',
    [5] = p.fl_magenta,
    [6] = p.fl_cyan,
    [7] = p.gray,
    [8] = p.gray,
    [9] = p.fl_red,
    [10] = p.fl_green,
    [11] = p.fl_yellow,
    [12] = p.fl_cyan,
    [13] = p.fl_magenta,
    [14] = p.fl_cyan,
    [15] = p.white,
  }
end

return M
