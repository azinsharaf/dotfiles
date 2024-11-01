# dir-open.yazi

open explorer of current located directory

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["g", 'd']
run  = "plugin dir-open"
desc = "open explorer of current dir"
```

Make sure the `['g', 'd']` key is not used elsewhere.
