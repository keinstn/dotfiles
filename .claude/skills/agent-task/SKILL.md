---
name: agent-task
description: Create a GitHub issue for an AI coding agent task. Use when asked to create an issue for an AI agent (e.g. "AI に依頼する issue を作って", "create an agent task issue", "open a task for the agent").
---

# Agent Task Issue

Create a GitHub issue formatted for AI coding agents. Follow the steps below.

## Step 1: Gather information

Collect the following from the user's description and current conversation context.
Ask clarifying questions for any missing required fields before proceeding.

| Field | Required | Description |
|---|---|---|
| Summary | yes | What is being built and why. Include background and motivation. |
| Scope | yes | What's in and explicitly what's out. The "out" prevents over-engineering. |
| Implementation notes | yes | Key files, patterns to follow, technical constraints. Name specific files if known. |
| Acceptance criteria | yes | Testable checklist. Tie each item to a command the agent can run to self-verify. |
| References | no | Related issues, PRs, documentation, or file paths. |

## Step 2: Format the issue body

Generate the body using this exact structure:

```
## Summary

<summary>

## Scope

In:
- <what's included>

Out (do NOT):
- Do NOT <what's excluded>

## Implementation notes

- <files and patterns>

## Acceptance criteria

- [ ] <criterion>
- [ ] All tests pass (`<test command>`)

## References

<references if any, omit section if none>
```

## Step 3: Create the issue

- Title: a concise, action-oriented description of the task
- Body: the formatted content from Step 2
- Use the GitHub MCP server if available; fall back to `gh issue create` otherwise
