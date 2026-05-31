---
name: understand-dashboard
description: Launch the interactive web dashboard to visualize a codebase's knowledge graph
argument-hint: [project-path]
---

1. Verify `knowledge-graph.json` exists in project's `.understand-anything/`
2. Find dashboard at `~/.understand-anything-plugin/packages/dashboard/`
3. Install deps: `cd <dashboard-dir> && pnpm install`
4. Build core: `cd <plugin-root> && pnpm --filter @understand-anything/core build`
5. Start Vite:
   in powerhsell: $env:GRAPH_DIR=<project-dir> npx vite --host 127.0.0.1
   in bash, zsh, or xonsh: `GRAPH_DIR=<project-dir> npx vite --host 127.0.0.1`
6. Capture the `?token=` URL from server output and share with user
