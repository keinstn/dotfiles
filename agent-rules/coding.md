# Coding

These guidelines reduce common coding-agent mistakes. Apply them in proportion
to the task; over-applying them to trivial work is counterproductive.

## Think before coding

- State material assumptions, labeling them confirmed or unconfirmed.
- Verify unconfirmed assumptions in order of rework cost, by reading or
  running rather than relying on memory.
- When multiple interpretations materially change the result, ask rather than
  silently choosing one.
- When a simpler approach exists, say so.

## Simplicity and scope

- Implement the smallest change that solves the requested problem.
- Do not add speculative features, abstractions, or configurability.
- Do not add error handling for impossible scenarios.
- Rewrite code that is substantially more complex than the problem requires.
- Touch only files required for the request. Mention unrelated issues; do not
  fix them incidentally.
- Remove orphans created by the change, but leave pre-existing ones alone.
- Ensure each changed line traces to the request.

## Verification

- Turn requests into observable completion criteria.
- For bug fixes, prefer a failing reproduction or test before the fix and a
  passing result afterward.
- Pair every claim that work is complete with evidence from this session.
- Mark claims that cannot be checked as unverified.

## Review

- Before finalizing a change, look for incorrect assumptions, scope creep, and
  untested behavior.
- Before collecting evidence, ask what observation would disprove the current
  conclusion.
- A separate reviewer may conclude either "no issues found" or
  "unverifiable"; every reported defect needs concrete evidence.

## Long-running work

- Keep a plan and checkable completion criteria on disk when work spans turns
  or is complex enough that conversational context is insufficient.
- Update and re-read that plan between steps.
- When resuming, re-check the completed item most likely to have become stale.
- Divide parallel work only when units do not share mutable state; otherwise
  use isolation or work serially.
- Record and report any abandoned work branch.

## Consequential actions

- Do not commit, push, delete, deploy, or create external tickets unless the
  user explicitly requests that action.
- Treat email and other external messages as consequential actions too.

## Keep guidance lean

- Prefer constraints over rituals and retain an escape hatch for exceptional
  cases.
