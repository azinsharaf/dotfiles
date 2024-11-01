# compress.yazi

compress selected files and folders with 7z


## Required

- [bandizip](https://en.bandisoft.com/bandizip/)

## Usage

Add this to your `~/.config/yazi/keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["g", 'z']
run  = "plugin compress"
desc = "compress of selected items"
```

Make sure the `['g', 'z']` key is not used elsewhere.
