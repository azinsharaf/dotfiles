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

For each changed file, determine which side is the source of truth before doing anything:

**Ask the user:** "Was this file edited on disk (outside chezmoi), or was it edited via chezmoi source?"
- If the **live file on disk is newer/correct** → use `chezmoi add <target-path>` to snapshot it into chezmoi source
- If the **chezmoi source is correct** → use `chezmoi apply <target-path>` to push it to disk
- If **unsure**, show the diff with `chezmoi diff <target-path>` and let the user decide

## Rules
- Never apply or add everything blindly — always confirm per file
- If files are passed as arguments to the command, handle only those files directly
- Show diffs clearly when requested — label which side is source vs disk
- After showing a diff, ask: "apply (source→disk), add (disk→source), or skip?"
- Warn explicitly before any destructive action (D=delete, overwriting newer file)
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
