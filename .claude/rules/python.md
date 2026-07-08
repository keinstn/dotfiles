# Python

## Use uv, not pip/venv/poetry directly

- Run: `uv run script.py` (not `python script.py`)
- One-off/CLI tools: `uvx <tool>` (not a global `pip install`)
- Dependency management: `uv add <pkg>` / `uv remove <pkg>` (not `pip
  install` or hand-editing requirements.txt)
- Virtual envs: `uv venv` (not `python -m venv` / `virtualenv`)

**Why:** reproducibility and speed via the lockfile.

**Exception:** if an existing project is already pinned to another tool
(poetry.lock, Pipfile, conda env.yml), follow that project's convention
instead (don't force a migration).
