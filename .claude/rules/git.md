# Git

## Commit messages: Conventional Commits 1.0.0

Spec: https://www.conventionalcommits.org/en/v1.0.0/

Structure:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- **type**: `feat` and `fix` are the only spec-defined types (`feat` = a new
  capability, `fix` = a bug fix). The rest follow the commitlint / Angular set
  the spec references: `build`, `chore`, `ci`, `docs`, `style`, `perf`,
  `refactor`, `test`, `revert`.
- **scope** (optional): the affected area in parentheses, lowercase noun. Reuse
  scopes already in this repo's history (e.g. `fish`, `herdr`, `windows`,
  `claude`) instead of inventing new ones.
- **description**: imperative mood, lowercase start, no trailing period.
  "add X", not "added X" / "adds X".
- **body** (optional): explain *why*, not *how*. Separated by a blank line.
- **breaking change**: append `!` before the colon (`feat!:`) and/or add a
  `BREAKING CHANGE: <what and migration>` footer.

Before committing, check the type matches the actual change: a rename is
`refactor`, new behavior is `feat`, tooling/config is `chore`. When torn
between two, pick the one a reader scanning the log would expect.
