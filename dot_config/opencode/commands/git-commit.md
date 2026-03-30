---
description: Create a git commit from staged files with a conventional commit message
agent: build
---

Look at the currently staged changes using `git diff --cached` and create a single git commit with a well-crafted message.

Rules:
- Only commit what is already staged. Do NOT stage any additional files.
- If there are no staged changes, inform me and do nothing.
- Use the Conventional Commits format: `type(scope): description`
  - Types: feat, fix, refactor, docs, style, test, chore, perf, ci, build
  - Scope is optional but encouraged when changes are focused on a specific area
  - Description should be lowercase, imperative mood, no period at end
- Keep the subject line under 72 characters
- Add a body (separated by blank line) only if the changes are complex and need explanation
- Do NOT push after committing
