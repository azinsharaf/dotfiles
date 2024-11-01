# open_nvim.yazi

force open file using nvim

## requires

- `neovim` : `scoop install neovim` (register nvim to environment variables)

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = 'o'
run  = "plugin open_nvim"
desc = "Open hovered files"
```
