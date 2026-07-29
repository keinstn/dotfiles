# Python

- Prefer `uv run` for scripts, `uvx` for one-off tools, and `uv add` or
  `uv remove` for dependency management.
- Prefer `uv venv` when a virtual environment is needed.
- Do not introduce direct `pip`, `venv`, or Poetry usage into a project that
  does not use them.
- If an existing project is pinned to Poetry, Pipenv, Conda, or another tool,
  follow that project's established convention instead of migrating it.
