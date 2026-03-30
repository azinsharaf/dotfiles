---
description: Push commits to remote
agent: build
---

Push the current branch's commits to the remote.

Rules:
- First run `git status` to check if there are unpushed commits
- If there are no unpushed commits, inform me and do nothing
- If the branch has no upstream, use `git push -u origin <branch>`
- Otherwise use `git push`
- NEVER force push
- Show the result after pushing
