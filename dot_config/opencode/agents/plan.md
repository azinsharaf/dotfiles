---
mode: primary
model: anthropic/claude-sonnet-4-6
permission:
  read: allow
  glob: allow
  grep: allow
  list: allow
  question: allow
  external_directory: allow
  webfetch: allow
  websearch: allow
  todowrite: allow
  task: allow
  edit: deny
  write: deny
  bash:
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "git branch*": allow
    "git show*": allow
    "git stash*": allow
    "git *": allow
    "*": ask
---
