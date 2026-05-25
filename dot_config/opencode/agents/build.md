---
mode: primary
model: anthropic/claude-sonnet-4-6
tools:
  write: true
  edit: true
  bash: true
  webfetch: true
  read: true
  grep: true
  glob: true
  list: true
  todowrite: true
  question: true
permission:
  edit: allow
  write: allow
  bash:
    "git add*": deny
    "git commit*": deny
    "git push*": deny
    "git status*": allow
    "git diff*": allow
    "git log*": allow
    "git branch*": allow
    "git show*": allow
    "git *": allow
    "*": ask
---
