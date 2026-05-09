---
description: Stage, commit, and push changes in one interactive workflow
agent: build
---

Run the full git workflow: stage selected files, commit, then push.

## Step 1 — Show current changes

Run `git status` and `git diff --stat` to get an overview of all changed, untracked, and deleted files.

Present the results as a **numbered list** of files with their status (modified, untracked, deleted).

Automatically flag and exclude (with a warning) any files that match:
- `.env`, `*.key`, `*.pem`, `*.p12`, `*.pfx`, `credentials.json`, `secrets.*`
- `node_modules/`, `dist/`, `build/`, `__pycache__/`, `*.pyc`
- Any file already covered by `.gitignore`

## Step 2 — Ask which files to stage

**Stop and ask the user:**

> Here are the changed files:
> [numbered list]
>
> Which files would you like to stage? Reply with numbers (e.g. `1 3 5`), `all`, or `none` to abort.

Wait for the user's reply before proceeding. Do not assume or proceed without an explicit answer.

## Step 3 — Stage the selected files

Using the user's selection:
- Use `git add` with explicit file paths only — never `git add .` or `git add -A`
- Show the resulting `git diff --cached --stat` so the user can see exactly what is staged

## Step 4 — Commit

Look at `git diff --cached` and create a commit with a well-crafted message following Conventional Commits format: `type(scope): description`
- Types: feat, fix, refactor, docs, style, test, chore, perf, ci, build
- Scope is optional but encouraged
- Description: lowercase, imperative mood, no trailing period
- Subject line under 72 characters
- Add a body only if the changes are complex

## Step 5 — Push

- Run `git status` to check the upstream state
- If the branch has no upstream, use `git push -u origin <branch>`
- Otherwise use `git push`
- NEVER force push
- Show the output after pushing
