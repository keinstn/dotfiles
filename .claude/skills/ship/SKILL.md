---
name: ship
description: Implement in a worktree, verify locally, then commit/push/PR and code-review. Use when asked to ship/deliver a change end-to-end (e.g. "ship して", "実装してPRまで作って").
---

# Ship

Deliver a change end-to-end using whatever tooling the project actually has —
don't assume a specific runner (`just`, `make`, `npm`, `uv`, etc.). Discover
it from the project's own docs/config (CLAUDE.md, README, justfile,
Makefile, package.json, ...) before running anything.

1. Follow the `worktree` skill to start in an isolated worktree (skip if
   already in one).
2. Implement the change.
3. Run the project's lint and full test suite; fix failures until green.
4. Run `/code-review` on the working-tree diff and fix findings — before
   committing, so the PR history doesn't carry separate "address review"
   fix-up commits.
5. Commit (Conventional Commits, per `git.md`), push, open a PR — commit
   messages, PR title/body, and any linked issue text in English.

## When NOT to use this

- Investigation-only requests — a diagnosis request isn't approval to create
  a worktree, branch, or PR; explain findings first and let the user confirm
  they want implementation.
