---
description: Safely stage files for git commit
agent: build
---

Review the current working tree changes using `git status` and `git diff`, then help me stage files for commit.

Rules:
- Show me a summary of all unstaged/untracked changes first
- Do NOT stage files that look like secrets or credentials (.env, *.key, *.pem, credentials.json, etc.)
- Do NOT stage build artifacts, node_modules, or other typically-gitignored files
- If a .gitignore exists, respect it
- Ask me which files to stage if there are multiple changed files, unless I specify files as arguments
- Use `git add` with explicit file paths — never use `git add .` or `git add -A`
- After staging, show the final `git status` so I can confirm before committing
