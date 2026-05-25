---
name: python-dev
description: Use when working on Python files, writing or fixing tests, implementing CLI commands, building TUI components, or reviewing Python code. Covers Python 3.12+ conventions, conda environments, type hints, testing patterns, and the common library stack (typer, rich, textual, pytest).
---

## Python version and environment

- **Python 3.12+** for all new code
- Use modern syntax: `X | Y` union types (not `Optional[X]` or `Union[X, Y]`), `match` statements, f-strings, `tomllib`
- Environments are **conda-based** — always check `environment.yml` for declared dependencies before suggesting installs
- Activate the project env before running anything: `conda activate <env-name>`
- If `environment.yml` is absent, check `pyproject.toml` `[project.dependencies]` or `[project.optional-dependencies]`
- Never suggest `pip install` for packages that are better served by conda-forge (e.g. GDAL, GEOS, Proj)

---

## Project structure conventions

```
<project>/
├── <package>/          # main source package (same name as project)
│   ├── __init__.py
│   ├── __main__.py     # entry point for python -m <package>
│   └── ...
├── tests/
├── environment.yml     # conda env definition
├── pyproject.toml      # build + tool config
└── README.md
```

- Entry points declared in `pyproject.toml` under `[project.scripts]`
- Versioning via `setuptools-scm` (reads from git tags) — do not hardcode version strings

---

## Type hints

- Required on **all** function signatures (parameters + return type)
- Use `from __future__ import annotations` at the top of files that have forward references
- Prefer built-in generics: `list[str]`, `dict[str, int]`, `tuple[int, ...]` (not `List`, `Dict` from `typing`)
- Use `TypeAlias` for complex reused types
- `Any` is a last resort — document why if used

---

## Docstrings

- **Google-style** docstrings
- Required on: all public classes, all public functions/methods, all modules
- Omit for private helpers (`_name`) unless the logic is non-obvious
- Example:
  ```python
  def get_info(self, limit: int | None = None) -> dict:
      """Return metadata about the dataset.

      Args:
          limit: Maximum number of features to inspect. None means all.

      Returns:
          Dict with keys: crs, extent, feature_count, geometry_type.

      Raises:
          FileNotFoundError: If the source file does not exist.
      """
  ```

---

## Imports

- Order: stdlib → third-party → local (blank line between each group)
- No star imports (`from module import *`)
- No unused imports — remove them
- Prefer explicit over implicit: `from pathlib import Path` not `import pathlib`

---

## Error handling

- Always catch specific exception types — never bare `except:`
- Use context managers (`with`) for file handles, database connections, and other resources
- Prefer `raise` over returning `None` to signal errors in library code
- Use `typer.Exit(code=1)` or `typer.BadParameter` for CLI-level errors, not raw `sys.exit()`

---

## CLI — typer

- Commands use `@app.command()` decorators
- Arguments: `typer.Argument(...)` with `help=` always set
- Options: `typer.Option(...)` with `help=` and sensible defaults
- Use `rich` for all user-facing output — no plain `print()` in CLI code
- Subcommands live in separate files imported into `cli.py`
- Test with `typer.testing.CliRunner` — monkeypatch dependencies, do not hit real I/O

---

## Terminal output — rich

- Use `rich.console.Console` (module-level instance) for all output
- Tables: `rich.table.Table` — always set `show_header=True`, use column styles
- Panels: `rich.panel.Panel` — for summary blocks
- Progress: `rich.progress.Progress` for long operations
- Never use `print()` for anything user-facing in CLI or library code

---

## TUI — textual

- Textual >= 0.70
- Each widget in its own file under `<package>/tui/widgets/`
- Visual theming in `.tcss` files — do not hardcode colors in Python widget code
- Use `DEFAULT_CSS` only for structural defaults (layout, sizing), not colors
- Vim keybindings follow the `VimTable` pattern (see geopeek if available)
- Reference other widgets via `self.app.query_one(WidgetClass)` — avoid circular imports
- Mount order in `app.py` determines DOM order

---

## Testing — pytest

- Framework: `pytest` with `pytest-asyncio` for async code
- `asyncio_mode = "strict"` in `pyproject.toml` — always use `@pytest.mark.asyncio` on async tests
- Use `tmp_path` fixture for temporary files — never hardcode paths
- Prefer `monkeypatch` over `unittest.mock` — it's cleaner and integrates better with pytest
- CLI tests use `typer.testing.CliRunner` with monkeypatched handlers — do not hit real files or GDAL
- TUI tests use `async with app.run_test() as pilot:` — `await pilot.press("key")` for input, `await pilot.pause()` after reactive updates
- Test error paths explicitly (bad input, missing file, unsupported format)
- File structure: mirror the source tree — `tests/test_<module>.py` for each module

---

## arcpy projects

- Use the **ArcGIS Pro Python environment** (`arcgispro-py3` conda env) — not Python 2.7
- Do not apply standard packaging assumptions (no `pyproject.toml`, no `setuptools-scm`)
- `arcpy` is only available inside the ArcGIS Pro env — do not import it in cross-platform code
- arcpy-specific conventions are defined separately; ask the user if unclear
- Never suggest `pip install arcpy` — it ships with ArcGIS Pro and cannot be installed independently

---

## Common patterns to follow

```python
# Path handling — always pathlib, never os.path
from pathlib import Path
file = Path(path_str)
if not file.exists():
    raise FileNotFoundError(f"File not found: {file}")

# Resource cleanup
with open(file, "r", encoding="utf-8") as f:
    data = f.read()

# Type-safe optional chaining
result = value if value is not None else default

# Prefer dataclasses or typed dicts over plain dicts for structured data
from dataclasses import dataclass

@dataclass
class LayerInfo:
    name: str
    crs: str
    feature_count: int
```

## Common anti-patterns to avoid

- `except Exception:` or bare `except:` — always be specific
- Mutable default arguments: `def fn(items=[])` — use `None` and initialize inside
- Shadowing builtins: `list = [...]`, `type = "..."`, `id = 123`
- `os.path` — use `pathlib.Path` instead
- `print()` for user-facing output in CLI code — use `rich.console.Console`
- `from module import *` — always explicit
