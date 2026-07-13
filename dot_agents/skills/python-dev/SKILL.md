---
name: python-dev
description: Use when working on Python files, writing or fixing tests, implementing CLI commands, building TUI components, reviewing Python code, configuring pyproject.toml, or wiring up linters/formatters/type checkers in Neovim. Covers Python 3.12+ conventions, conda and uv environments, type hints, typer, rich, textual, pytest, Mason-managed tooling, and concurrency patterns.
---

## Python version and environment

- **Python 3.12+** for all new code
- Use modern syntax: `X | Y` union types (not `Optional[X]` or `Union[X, Y]`), `match` statements, f-strings, `tomllib`, `Self`, `Literal[...]`
- Environments are **conda-based or uv** — always check `environment.yml` or `pyproject.toml` for declared dependencies before suggesting installs
- Activation depends on the env type:
  - conda env: `conda activate <env-name>`
  - uv venv: `source .venv/bin/activate` (uv creates `.venv` by default)
- If `environment.yml` is absent, check `pyproject.toml` `[project.dependencies]` or `[dependency-groups]`
- Never suggest `pip install` for packages that are better served by conda-forge (e.g. GDAL, GEOS, Proj)
- Use ArcGIS Pro Python interpreter if `arcpy` library is used in the code

---

## Tooling (managed via Neovim Mason)

- All Python tooling (lint, format, type check) is managed through **Mason** in Neovim — do not assume global installs
- Recommended Mason packages: `ruff` (lint + format), `mypy` or `pyright` (type check), `debugpy` (DAP), `pytest`
- `ruff` replaces `flake8`, `isort`, `black`, and most of `pylint` — use it as the single linter/formatter
- Configure `ruff`, `mypy`, and `pytest` in `pyproject.toml` under `[tool.ruff]`, `[tool.mypy]`, `[tool.pytest.ini_options]`
- `pyproject.toml` is the single source of truth for: project metadata, dependencies, dependency groups, tool configuration, and `[project.scripts]` entry points
- Run formatters/linters from CLI in headless contexts (CI, pre-commit, scripts): `ruff check .`, `ruff format .`, `mypy .`

---

## Project structure conventions

```
<project>/
├── <package>/          # main source package (same name as project)
│   ├── __init__.py     # declare public API with __all__
│   ├── __main__.py     # entry point for python -m <package>
│   └── ...
├── tests/
├── environment.yml     # conda env definition (if conda-based)
├── pyproject.toml      # source of truth for deps, tools, scripts
└── README.md
```

- Declare public API explicitly in `__init__.py` using `__all__` — do not rely on "imports happen to work"

---

## Type hints

- Required on **all** function signatures (parameters + return type)
- Use `from __future__ import annotations` at the top of files that have forward references
- Prefer built-in generics: `list[str]`, `dict[str, int]`, `tuple[int, ...]` (not `List`, `Dict` from `typing`)
- Use `TypeAlias` for complex reused types
- `Any` is a last resort — document why if used
- Use modern typing features:
  - `Self` for methods returning their own class
  - `Literal["a", "b"]` for closed string/int sets
  - `Protocol` for structural typing (duck typing with type safety)
  - `TypedDict` for dict-shaped data with known keys
  - `TypeVar` with `default=` when available (3.13+)

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
- No star imports (`from module import *`) — re-export via `__all__` instead
- No unused imports — remove them
- Prefer explicit over implicit: `from pathlib import Path` not `import pathlib`

---

## Error handling

- Always catch specific exception types — never bare `except:`
- Use context managers (`with`) for file handles, database connections, and other resources
- Prefer `raise` over returning `None` to signal errors in library code
- Use `typer.Exit(code=1)` or `typer.BadParameter` for CLI-level errors, not raw `sys.exit()`
- Chain exceptions explicitly: `raise NewError("context") from original` — never lose the cause
- Define a custom exception hierarchy per package (base class + specific subclasses)
- Use `contextlib.suppress(SpecificError)` only when the swallow is intentional and documented

---

## Logging

- Use the `logging` module — never `print()` for non-CLI diagnostics
- Module-level logger: `logger = logging.getLogger(__name__)`
- Library code must not configure handlers — emit records, let the application configure
- CLI code may configure handlers via `rich.logging.RichHandler` for formatted output
- Use `%`-style formatting in log calls, not f-strings (deferred evaluation):
  ```python
  logger.info("Processing %d items", count)  # good
  logger.info(f"Processing {count} items")   # bad — always evaluated
  ```

---

## CLI — typer

- Commands use `@app.command()` decorators
- Arguments: `typer.Argument(...)` with `help=` always set
- Options: `typer.Option(...)` with `help=` and sensible defaults
- Use `rich` for all user-facing output — no plain `print()` in CLI code
- Subcommands live in separate files imported into `cli.py`
- Test with `typer.testing.CliRunner` — monkeypatch dependencies, do not hit real I/O
- Testing pattern:
  ```python
  from typer.testing import CliRunner
  from package.cli import app

  runner = CliRunner(mix_stderr=False)
  result = runner.invoke(app, ["command", "--flag", "value"])
  assert result.exit_code == 0
  assert "expected" in result.stdout
  ```

---

## Terminal output — rich

- Use `rich.console.Console` (module-level instances) for all output
- Module-level instances:
  - `_stdout = Console()` for normal output
  - `_stderr = Console(stderr=True)` for errors and warnings
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
- Use **reactive attributes** for state that drives UI updates: `count: reactive[int] = reactive(0)`
- Use **messages** for inter-widget communication: define a `Message` subclass and post via `self.post_message(...)`, handle with `@on(MyMessage)` on the recipient

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
- Use `@pytest.mark.parametrize` for table-driven tests — one test function, many cases
- Use `pytest-cov` for coverage — set a minimum threshold in `pyproject.toml` (`[tool.coverage.report] fail_under = 80`)
- Use snapshot testing for stable CLI/structured output: `syrupy` or `inline-snapshot`

---

## Concurrency

- **asyncio.TaskGroup** (3.11+) for structured concurrency — preferred over `asyncio.gather` for new code:
  ```python
  async with asyncio.TaskGroup() as tg:
      tg.create_task(fetch_a())
      tg.create_task(fetch_b())
  ```
- `concurrent.futures.ThreadPoolExecutor` for I/O-bound parallelism (network, file I/O)
- `concurrent.futures.ProcessPoolExecutor` for CPU-bound work
- Never mix threads and asyncio without `asyncio.to_thread` (3.9+)
- `async` is not automatically faster — only use it for I/O-bound workloads with many concurrent operations

---

## Security

- Use the `secrets` module for tokens, keys, and passwords — never `random`
- Never commit secrets — use environment variables or a secret manager
- Run `pip-audit` (or `uv pip audit`) in CI to scan for known CVEs
- Validate untrusted input at boundaries — type hints are not runtime validation
- Prefer `subprocess.run([...], check=True, shell=False)` over `os.system` — never `shell=True` with user input

---

## Documentation

- Public libraries ship docs — use **mkdocs** with `mkdocstrings` (auto-generates from docstrings) or **Sphinx** with `autodoc`
- Keep docstrings and reference docs in sync — docstrings are the source of truth
- `README.md` is for newcomers; full reference docs go in `docs/`
- For TUI/CLI projects, include a `--help` example and a minimal usage block in README

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

# Atomic file writes — write to temp, then rename
import tempfile
import os
with tempfile.NamedTemporaryFile("w", delete=False, dir=file.parent) as tmp:
    tmp.write(content)
    tmp_path = tmp.name
os.replace(tmp_path, file)

# Parsing config files
import tomllib  # stdlib in 3.11+
with open("pyproject.toml", "rb") as f:
    config = tomllib.load(f)
```

## Common anti-patterns to avoid

- `except Exception:` or bare `except:` — always be specific
- Mutable default arguments: `def fn(items=[])` — use `None` and initialize inside
- Shadowing builtins: `list = [...]`, `type = "..."`, `id = 123`
- `os.path` — use `pathlib.Path` instead
- `print()` for user-facing output in CLI code — use `rich.console.Console`
- `print()` for diagnostics in library code — use `logging`
- `from module import *` — always explicit
- `assert` for runtime validation — stripped under `python -O`
- `time.sleep` in tight loops or tests — use mocks or proper async waits
- Re-exports without `__all__` in `__init__.py` — define the public surface explicitly
- `random` for security-sensitive values — use `secrets`
- `os.system` or `subprocess` with `shell=True` on user input — injection risk
- f-strings in logging calls — use `%` formatting to defer cost
