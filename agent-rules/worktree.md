# Worktrees

For multi-file, risky, or independently shippable implementation work in a
Git repository, prefer an adjacent Git worktree. Do not create another
worktree when already in an isolated one or when the user requests in-place
work.
