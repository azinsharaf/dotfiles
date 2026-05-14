---
description: Summarise full git state (unstaged, staged, unpushed, stash) and recommend the best next git command to run
---

Run the following git commands and analyse the output holistically:

1. `git status` — show the working tree state
2. `git diff --stat` — summarise unstaged changes
3. `git diff --cached --stat` — summarise staged changes
4. `git log --oneline @{u}..HEAD 2>$null || git log --oneline -10` — commits not yet pushed (falls back to last 10 if no upstream)
5. `git stash list` — show any stashed work

Then produce a clear, structured report:

## 🗂 Working Tree (Unstaged)
List modified/deleted/untracked files not yet staged. If none, say so.

## 📦 Staged (Ready to Commit)
List files staged but not yet committed. If none, say so.

## 🚀 Committed but Not Pushed
List commits that exist locally but haven't been pushed to the remote. If none, say so.

## 🗄 Stash
List any stashed changesets. If none, say so.

## 💡 Recommended Next Step
Recommend the single best git command (or short sequence) to run next, with a one-line reason. Be specific with flags (e.g. `git commit -m "..."` vs `git commit --amend`). If everything is clean and pushed, say so.
