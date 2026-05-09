---
description: Selectively apply chezmoi dotfiles to the system
agent: build
---

Run `chezmoi status` to show all pending changes (files that differ between the chezmoi source and the target system), then help me apply only the files I choose.

Rules:
- Start by running `chezmoi status` and present the output clearly, explaining what each status code means (A=add, M=modify, D=delete, R=re-add)
- List all changed files and ask me which ones I want to apply — never apply everything blindly
- If I specify files as arguments to the command, apply only those files directly without asking
- For each changed file (or any file I ask about), offer to show the diff using `chezmoi diff <target-path>` before applying — present the diff clearly so I can decide to skip or overwrite
- After showing a diff, ask me: skip this file, or apply it?
- Apply selected files using `chezmoi apply <file1> <file2> ...` with explicit target paths (the destination paths, not the source paths)
- After applying, run `chezmoi status` again to confirm the changes were applied successfully
- If a file would overwrite something destructively (e.g. a delete), warn me before proceeding
