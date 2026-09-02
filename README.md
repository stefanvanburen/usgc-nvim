# USGC Neovim Color Schemes

Neovim port of the [U.S. Graphics Company color schemes](https://github.com/usgraphics/usgc-themes).

All credit for the original color schemes goes to [U.S. Graphics Company](https://usgraphics.com/).

## Requirements

- Neovim 0.8+
- `'termguicolors'` enabled (these themes use true color only, no cterm fallback)

## Installation

```lua
vim.opt.termguicolors = true
vim.pack.add({ 'https://github.com/stefanvanburen/usgc-nvim' })
-- e.g.
vim.cmd.colorscheme('usgc-highk')
```

## Themes

`usgc` follows `'background'`, and switches when it does:

```lua
vim.cmd.colorscheme('usgc')
```

It uses `usgc-highk` when `'background'` is `light` and `usgc-polyimide` when
it is `dark`. Name either explicitly with `vim.g.usgc_light` and
`vim.g.usgc_dark`, set before the colorscheme loads. The variants can also be
selected directly:

| Part Number | Theme Name       | Description    |
|-------------|------------------|----------------|
| 5200-010    | `usgc-highk`     | White scheme   |
| 5200-020    | `usgc-reticle`   | Dark scheme    |
| 5200-030    | `usgc-polyimide` | Amber scheme   |
| 5200-040    | `usgc-epitaxy`   | Magenta scheme |
| 5200-050    | `usgc-metalgate` | Cyan scheme    |

## Standard Colors

The themes use the USGC standard color palette:

| Hex Color | Name        |
|-----------|-------------|
| `#000000` | BLACK       |
| `#FFFFFF` | WHITE       |
| `#FF0000` | FL RED      |
| `#00FF00` | FL GREEN    |
| `#0000FF` | FL BLUE     |
| `#00FFFF` | FL CYAN     |
| `#FF00FF` | FL MAGENTA  |
| `#FFFF00` | FL YELLOW   |
| `#FF6600` | FL ORANGE   |
| `#660000` | MAROON      |
| `#00A645` | GREEN       |
| `#000066` | BLUE        |
| `#006666` | CYAN        |
| `#660066` | MAGENTA     |
| `#FFBF00` | YELLOW      |
| `#666600` | OLIVE       |
| `#999999` | GRAY        |

## Terminal themes

`contrib/` generates matching themes for the terminal by reading the colors back
out of Neovim, so the two cannot drift. Each script writes one file per
colorscheme, into the directory given as its first argument or the default
below.

[Ghostty](https://ghostty.org), into `$XDG_CONFIG_HOME/ghostty/themes`:

```sh
nvim -l contrib/ghostty.lua
```

Select one by name, e.g. `theme = light:usgc-highk,dark:usgc-polyimide`.

[fish](https://fishshell.com), into `$XDG_CONFIG_HOME/fish/themes`:

```sh
nvim -l contrib/fish.lua
```

Then `fish_config theme choose usgc-reticle` for the current session, or
`fish_config theme save usgc-reticle` to keep it.

## License

MIT License - See [LICENSE](LICENSE)

Original color schemes by [U.S. Graphics Company](https://github.com/usgraphics/usgc-themes).
