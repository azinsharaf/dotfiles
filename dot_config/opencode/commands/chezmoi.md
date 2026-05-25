---
description: Review chezmoi status and selectively sync dotfiles — either apply (source→disk) or add (disk→source)
agent: build
---

Run `chezmoi status` to show all pending changes (files that differ between the chezmoi source and the target system), then help me sync only the files I choose.

## Status codes
- `A` = Add — file exists in source but not on disk
- `M` = Modify — file differs between source and disk
- `D` = Delete — file exists on disk but not in source
- `R` = Re-add — file on disk differs from source (reverse drift)
- First character = what chezmoi source would do to disk
- Second character = how the disk file has changed since chezmoi last recorded it

## Direction: always ask before acting

For each changed file, determine which side is the source of truth before doing anything.

### Step 1 — Gather signals automatically

For every file in `chezmoi status`, collect **all three signals in parallel** before asking the user anything:

1. **Modified dates** — compare disk mtime vs source mtime:
   - Get the source path via `chezmoi source-path` then resolve the source file path
   - Use `powershell -Command "Get-Item <path> | Select-Object LastWriteTime"` for each side
   - Report which side is newer and by how much

2. **Diff** — run `chezmoi diff <target-path>` and show it, labelled:
   - `--- source (chezmoi repo)` = what chezmoi has
   - `+++ disk (live file)` = what is on disk

3. **Template check** — check if the chezmoi source file ends in `.tmpl`:
   - Run `chezmoi source-path <target-path>` to get the exact source filename
   - If the filename ends in `.tmpl`, print a prominent warning:
     **"⚠ WARNING: This file is a chezmoi template (.tmpl). Running `chezmoi add` will overwrite the template with the rendered output, destroying all template expressions. Do NOT add unless you intend to convert this to a plain file."**

### Step 2 — Ask the user per file

After showing all three signals, ask:
> "apply (source→disk), add (disk→source), or skip?"

- If the **disk is newer** and no template warning → suggest `add`
- If the **source is newer** → suggest `apply`
- If **template warning is active** → strongly recommend `apply` or `skip`, never suggest `add`
- Modified date is a hint only — always defer to the user's explicit choice

### Step 3 — Act

- `add` chosen → run `chezmoi add <target-path>`
- `apply` chosen → run `chezmoi apply <target-path>`
- `skip` → move on

## Rules
- Never apply or add everything blindly — always confirm per file
- If files are passed as arguments to the command, handle only those files directly
- Warn explicitly before any destructive action (D=delete, overwriting newer file)
- Modified date is a useful hint but not authoritative — always show the diff too
- After all selected files are handled, run `chezmoi status` again to confirm the result

## Phase 2: Commit & push the chezmoi source repo

After syncing is complete, check the git state of the chezmoi source directory (`chezmoi source-path` to get the path) by running `git status` inside it.

If there are uncommitted or unpushed changes, follow the same rules as the existing git commands:

**Staging** (follows `/git-add` rules):
- Show a summary of unstaged/untracked changes
- Never stage secrets, credentials, or build artifacts
- Use explicit file paths — never `git add .` or `git add -A`
- Ask which files to stage unless it's obvious (e.g. only the files we just synced)

**Committing** (follows `/git-commit` rules):
- Only commit what is staged
- Use Conventional Commits format: `type(scope): description`
- Scope should reflect the dotfile area changed (e.g. `opencode`, `qutebrowser`, `flow-launcher`)
- Keep subject line under 72 characters
- Do NOT push after committing without asking

**Pushing** (follows `/git-push` rules):
- Check for unpushed commits first
- Use `git push -u origin <branch>` if no upstream is set
- Otherwise use `git push`
- NEVER force push
- Show the result after pushing

Ask the user at each step: stage? commit? push? — never do all three automatically.
