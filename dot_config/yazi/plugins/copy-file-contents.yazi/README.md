# Copy-file-contents.yazi

A simple plugin to copy file contents just from Yazi without going into editor. (for windows)

## Features

- Copy one or more file contents to clipboard.
- Set custom separator for copied contents.
- Set custom clipboard command.

## Usages

Add the below keybinding to your `~/.config/yazi/keymaps.toml` file.

```toml
[[manager.prepend_keymap]]
on = ["c", "g"]
run = ["plugin copy-file-contents"]
desc = "Copy contents of file"
```

