---
name: self-reload
description: End this Claude Code session and immediately resume the same conversation (picks up an upgraded binary). Does not run brew upgrade.
disable-model-invocation: true
---

Requires claude to be launched from fish with the `claude` wrapper (`~/.config/fish/claude-self-reload.fish`).

The resumed session gets only `--resume <id>`; original launch flags (model, permission mode, --add-dir) are not carried over.

Run this single Bash command, nothing else:

```
~/.claude/skills/self-reload/reload.sh
```

If the shell isn't using the wrapper, the session just exits; resume manually with `claude --resume <id>` (the script prints the id before killing).
