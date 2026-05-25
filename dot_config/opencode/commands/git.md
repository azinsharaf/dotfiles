---
description: Stage, commit, and push — interactive step-by-step git workflow
agent: build
---

Run the full git workflow interactively. Each step requires explicit confirmation. Saying no at any step stops all remaining steps.

## Step 1 — Show current changes

Run `git status` and `git diff --stat`.

Build a **numbered list** of all changed, untracked, and deleted files with their status (modified / untracked / deleted).

Before showing the list, silently flag and exclude any files matching:
- `.env`, `*.key`, `*.pem`, `*.p12`, `*.pfx`, `credentials.json`, `secrets.*`
- `node_modules/`, `dist/`, `build/`, `__pycache__/`, `*.pyc`
- Any file already in `.gitignore`

Show excluded files as a warning below the list (do not number them).

If there are no changed files, inform the user and stop.

## Step 2 — Stage

Ask:
> Stage files? (yes / no)

- **no** → stop
- **yes** → ask: "Which files? Enter numbers (e.g. `1 3`), or `all`"

Wait for the user's reply. Then:
- Use `git add` with explicit file paths only — never `git add .` or `git add -A`
- Show `git status` after staging so the user can confirm what's staged

## Step 3 — Commit

Ask:
> Commit? (yes / no)

- **no** → stop
- **yes** → delegate to the `commit-writer` subagent to generate a commit message from the staged diff

Show the proposed message:
```
Proposed commit message:

  <message>

Confirm? (yes / edit / no)
```

- **no** → stop, leave files staged
- **edit** → ask: "Enter your commit message:" → use that message
- **yes** → run `git commit -m "<message>"` → show the result (hash + summary)

After a successful commit, delegate to the `docs-sync` subagent. It runs silently — do not mention it to the user unless it surfaces a finding.

## Step 4 — Push

Ask:
> Push? (yes / no)

- **no** → stop
- **yes** → check upstream:
  - No upstream set: `git push -u origin <branch>`
  - Upstream exists: `git push`
  - NEVER force push
  - Show the output after pushing
