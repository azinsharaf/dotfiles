---
name: geopeek-dev
description: Development guide for geopeek — a Python CLI/TUI tool for inspecting geospatial datasets (shapefiles, rasters, GDBs). Covers architecture, handler pattern, TUI widgets, testing, and git conventions.
---

## What I do

Guide development of the geopeek project:
- Implement new geospatial format handlers following the abstract Handler pattern
- Build Textual TUI widgets with Catppuccin Mocha theming and vim keybindings
- Write pytest + pytest-asyncio tests matching project style
- Enforce Conventional Commits and suggest changelogs

---

## Project identity

- **Repo:** `C:\Users\azin\repos\geopeek` (also `~/repos/geopeek`)
- **What it is:** Terminal CLI + interactive TUI for inspecting geospatial datasets (shapefiles, rasters, file geodatabases)
- **Python:** 3.12 (conda env named `geopeek`, defined in `environment.yml`)
- **Entry point:** `geopeek = "geopeek.cli:app"` via Typer
- **Run tests:** `python -m pytest tests/ -v`
- **Run app:** `python -m geopeek` or `geopeek browse [path]`

---

## Architecture

```
geopeek/
├── geopeek/
│   ├── cli.py                  # Typer CLI: info, peek, schema, extent, browse
│   ├── __main__.py             # python -m geopeek entry
│   ├── handlers/
│   │   ├── handler.py          # Abstract base class: Handler
│   │   ├── shapefile_handler.py  # .shp via osgeo.ogr
│   │   ├── raster_handler.py     # .tif/.tiff/.jp2/etc via osgeo.gdal
│   │   └── gdb_handler.py        # .gdb via osgeo.ogr (multi-layer)
│   ├── output/
│   │   ├── rich_printer.py     # Rich terminal tables/panels
│   │   └── json_printer.py     # JSON output
│   └── tui/
│       ├── app.py              # Main Textual App class
│       ├── theme.py            # Catppuccin Mocha CSS variables
│       ├── styles/
│       │   ├── app.tcss        # Global layout
│       │   └── index.tcss      # Component styles
│       └── widgets/
│           ├── explorer.py     # File tree sidebar (DirectoryTree subclass)
│           ├── data_panel.py   # Attribute grid panel (tabs: Attributes + Fields)
│           ├── fields_panel.py # Schema/fields tab content
│           └── vim_table.py    # DataTable with vim keybindings + inline search
├── tests/
│   ├── test_cli.py             # Typer CliRunner tests with DummyHandler
│   ├── test_handlers.py        # Unit tests for all three handlers
│   ├── test_tui.py             # Textual pilot async tests
│   └── test_vim_motions.py     # Vim keybinding, search, highlight tests
├── sample_data/
│   ├── shapefiles/             # US AIANNH 500k .shp
│   ├── rasters/                # DEM.tif
│   └── file_gdb/               # US Pacific .gdb
├── pyproject.toml
├── environment.yml
└── AGENT.md                    # Future roadmap notes
```

---

## Handler pattern — adding a new format

All format support flows through the abstract base class in `geopeek/handlers/handler.py`.

### 1. Implement the handler

```python
# geopeek/handlers/my_format_handler.py
from .handler import Handler

class MyFormatHandler(Handler):
    # Class-level list of supported extensions (lowercase, with dot)
    SUPPORTED_EXTENSIONS = [".xyz"]

    def get_info(self) -> dict:
        """Return metadata: crs, extent, geometry_type, feature_count, etc."""
        ...

    def get_data(self, limit: int | None = None) -> dict:
        """Return attribute rows as list of dicts."""
        ...

    def get_schema(self) -> dict:
        """Return field names and types."""
        ...

    def get_extent(self) -> dict:
        """Return bounding box as {xmin, ymin, xmax, ymax}."""
        ...
```

### 2. Register in cli.py

In `geopeek/cli.py`, the handler is selected by file extension. Find the `_get_handler()` helper (or equivalent dispatch dict) and add:

```python
".xyz": MyFormatHandler,
```

### 3. Add to TUI explorer filter

In `geopeek/tui/widgets/explorer.py`, the `SHOW_EXTENSIONS` set (or `filter_paths` method) controls which files appear in the file tree. Add the new extension there.

### 4. Write tests

Add cases to `tests/test_handlers.py` following the `tmp_path` fixture pattern. For CLI coverage, add a monkeypatched `DummyHandler` case in `tests/test_cli.py`.

---

## TUI conventions

### Framework & theme

- **Textual** >= 0.70 for all TUI code
- **Theme:** Catppuccin Mocha — CSS variables are defined in `geopeek/tui/theme.py` and imported into TCSS files
- Use `$surface`, `$overlay`, `$text`, `$mauve`, `$green`, `$blue` etc. from the theme — do NOT hardcode hex colors in widgets

### Widget structure rules

- Each widget lives in its own file under `geopeek/tui/widgets/`
- Widgets use `DEFAULT_CSS` class variable for inline styles only for structural defaults; visual theming goes in `.tcss` files
- Mount order in `app.py` determines DOM order and layout
- Use `self.app.query_one(WidgetClass)` to get references between widgets; avoid direct imports creating circular deps

### Vim keybinding pattern

The `VimTable` widget (`widgets/vim_table.py`) is the reference implementation. Follow this pattern for any new vim-navigable widget:

```python
BINDINGS = [
    Binding("j", "move_down", "Down", show=False),
    Binding("k", "move_up", "Up", show=False),
    Binding("g,g", "move_top", "Top", show=False),
    Binding("shift+g", "move_bottom", "Bottom", show=False),
    Binding("ctrl+d", "page_down", "Page down", show=False),
    Binding("ctrl+u", "page_up", "Page up", show=False),
    Binding("/", "search", "Search", show=True),
    Binding("n", "next_match", "Next", show=False),
    Binding("shift+n", "prev_match", "Prev", show=False),
    Binding("escape", "clear_search", "Clear", show=False),
]
```

- Inline search highlights use Textual's `highlight` method on the DataTable
- `z,z` centers the cursor row in view

### TCSS file conventions

- Layout in `styles/app.tcss` (dock, grid, height/width)
- Component-specific styles in `styles/index.tcss`
- Use `&:focus` and `&.-active` pseudo-selectors for focus states

---

## Testing guide

### Running tests

```bash
python -m pytest tests/ -v
# async tests handled automatically via asyncio_mode = "strict" in pyproject.toml
```

### CLI tests (`test_cli.py`)

Use `typer.testing.CliRunner` and monkeypatch the handler to avoid real GDAL:

```python
from typer.testing import CliRunner
from geopeek.cli import app

def test_info_command(monkeypatch):
    monkeypatch.setattr("geopeek.cli._get_handler", lambda path: DummyHandler(path))
    result = CliRunner().invoke(app, ["info", "fake.shp"])
    assert result.exit_code == 0
```

### Handler tests (`test_handlers.py`)

- Use `tmp_path` for files that need to exist on disk
- For GDAL-dependent tests, either use `sample_data/` files or skip with `pytest.importorskip("osgeo")`
- Test error paths (nonexistent file, unsupported format) separately

### TUI tests (`test_tui.py`, `test_vim_motions.py`)

```python
import pytest
from textual.pilot import Pilot
from geopeek.tui.app import GeopeekApp

@pytest.mark.asyncio
async def test_app_mounts():
    app = GeopeekApp()
    async with app.run_test() as pilot:
        assert app.query_one("Explorer") is not None
```

- Use `await pilot.press("j")` to simulate keystrokes
- Use `await pilot.pause()` after actions that trigger reactive updates
- `asyncio_mode = "strict"` is already set — always use `@pytest.mark.asyncio`

---

## Git conventions

**Format:** `type(scope): short description` (Conventional Commits)

| Type | When |
|---|---|
| `feat` | New feature or format support |
| `fix` | Bug fix |
| `refactor` | Internal restructuring, no behavior change |
| `test` | Adding or fixing tests |
| `docs` | README, docstrings, AGENT.md |
| `chore` | Deps, build, config |

**Active scopes:** `tui`, `cli`, `data`, `handlers`, `tests`, `docs`

**Examples from the repo:**
```
feat(tui): keyboard navigation for tab bar with contextual hint
feat(data): progressive row loading for vector datasets
feat(tui): add vim motions, inline search, and match highlighting
docs: update README with vim keybindings and progressive loading
```

---

## Known gaps to address proactively

When relevant, suggest or offer to implement:

1. **No CI/CD** — no `.github/workflows/` exists; offer to create a GitHub Actions workflow for `pytest` on push/PR
2. **Ruff not configured** — Ruff cache exists but no `[tool.ruff]` in `pyproject.toml`; offer to add linting config
3. **Conda recipe placeholder** — `conda/meta.yaml` still has `yourusername` in the `home` URL
4. **No version tag** — `setuptools-scm` reads from git tags; suggest tagging a `v0.1.0` release when ready

---

## Supported file formats

| Extension | Handler | Notes |
|---|---|---|
| `.shp` | ShapefileHandler | via osgeo.ogr |
| `.gdb` | GDBHandler | multi-layer; sidebar shows layers as children |
| `.tif`, `.tiff` | RasterHandler | via osgeo.gdal |
| `.jp2`, `.png`, `.jpg`, `.img`, `.vrt`, `.dem` | RasterHandler | same handler, different extensions |
