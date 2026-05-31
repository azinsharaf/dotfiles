---
name: understand
description: Analyze the current codebase and produce a knowledge graph.
---

Load the understand skill at `~/.agents/skills/understand/SKILL.md` and execute its pipeline.

**Pre-flight:**

1. Verify plugin is built: `[ -f ~/.understand-anything-plugin/packages/core/dist/index.js ]`
2. Resolve PROJECT_ROOT from arguments (default: current directory)
3. Create intermediate dirs: `mkdir -p $PROJECT_ROOT/.understand-anything/{intermediate,tmp}`
4. Write config: `--no-auto-update` → `{"autoUpdate": false}`, `--language en` → `{"outputLanguage": "en"}`
5. Generate `.understandignore` if missing

**Execute deterministic scripts:**

```bash
node ~/.understand-anything/repo/understand-anything-plugin/skills/understand/scan-project.mjs <projectRoot> <outputPath>
node ~/.understand-anything/repo/understand-anything-plugin/skills/understand/extract-import-map.mjs <input.json> <output.json>
node ~/.understand-anything/repo/understand-anything-plugin/skills/understand/compute-batches.mjs <projectRoot>
```
