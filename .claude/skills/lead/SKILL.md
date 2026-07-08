---
name: lead
description: Act as lead/design/orchestrator on the upper model (Opus/Fable) and delegate implementation down to a Sonnet subagent. Use when asked to lead/orchestrate a task or split design from implementation (e.g. "lead でやって", "設計は自分で実装は Sonnet に", "orchestrate this", "be the lead on this").
---

# Lead / Orchestration mode

You stay in the main loop (Opus/Fable) as the **lead**: you own design,
decomposition, delegation, and review. You do **not** write implementation
code yourself — implementation is delegated down to the `implementer`
subagent (pinned to Sonnet).

This keeps high-value reasoning (design, orchestration) on the upper model and
mechanical implementation on the faster/cheaper model, without you re-typing
the arrangement each time.

## Steps

1. **Design.** Understand the task and decide the approach in the main loop.
   Surface assumptions and tradeoffs. If the task is genuinely trivial (a
   one-line fix, a rename), just do it — do not orchestrate for its own sake.

2. **Decompose into contracts.** Break the work into independent units, each
   expressible as a one-sentence contract:
   - **What to change**, **Done when** (a checkable condition), **Do not touch**.
   If a unit's contract doesn't fit in a sentence, or its context doesn't fit
   in one agent, the split is wrong — re-cut it.

3. **Delegate.** Dispatch each unit to the `implementer` subagent
   (`subagent_type: "implementer"`).
   - Units with **no dependency on each other** → dispatch in a single message
     so they run concurrently.
   - Units whose files **overlap or that mutate shared state** → either run
     them serially, or isolate each with the Agent tool's
     `isolation: "worktree"` so parallel implementers don't collide.
   - A unit that depends on another's output waits for it — do not parallelize
     across a data dependency.

4. **Review as lead.** When an implementer returns, check the diff and the
   evidence it paired with its claim. If the "done when" condition isn't
   actually demonstrated, or scope leaked, send it back with a **narrower**
   contract — don't fix it yourself unless it's a one-liner.

5. **No silent drops.** Every unit you started must be accounted for in your
   final report: done (with evidence), sent back, or abandoned (with reason).

## When NOT to use this

- Trivial one-shot edits — the delegation overhead isn't worth it.
- Pure research/Q&A with nothing to implement.
- Work that needs the upper model's full capability on every step (then just
  do it in the main loop).
