# diff.yazi

Diff the selected file with the hovered file using `nvim -d`

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["g", "f"]
run  = "plugin diff"
desc = "Diff the selected with the hovered file"
```
