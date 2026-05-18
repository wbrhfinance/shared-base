---
name: enhance-last-skill
description: >
  Cross-firm feedback-loop skill. Takes a SKILL.md path plus optional output
  samples and user feedback, reviews the skill against what actually happened
  in a recent session, and proposes 1 to 3 concrete patches (where in the file,
  what current text, what proposed text, why). Never auto-applies. Prevents a
  skill from silently degrading itself while still letting it improve fast.
firm: shared
version: 0.1.0
status: active
agnostic: false
created: '2026-05-18'
last_updated: '2026-05-18'
last_used:
usage_count: 0
---

# Enhance Last Skill

## Purpose

After a session that used a specific skill, draft small, targeted patches to that skill's `SKILL.md` based on what worked and what didn't. The Marchese pattern: prompt the skill, not Claude. Sharpen the skill every time it's used.

Trigger: `enhance the skill we just used`, `refine that skill`, `what would improve <skill-name>?`, or as the closing step of any runbook.

## Inputs

1. **Path to a SKILL.md.** Required. Absolute path so this works from any session.
2. **Output samples.** Optional. One or more recent outputs of the skill, ideally one good and one weak.
3. **User feedback.** Optional. Free-text comments ("the output was too long", "missed source X", "wrong tone").

If only the path is supplied, ask **one** clarifying question to pick a focus (latest output, recurring issue, or a specific section). Never ask multiple questions.

## Procedure

1. **Read the SKILL.md fully.** Frontmatter and body.
2. **Compare against outputs.** For each sample, mark which rules in the skill were followed, which were violated, which were silent on the issue.
3. **Locate the gap.** Each weakness should point to either a missing rule, a vague rule, or a contradicting rule in the skill. Be specific.
4. **Draft patches.** Maximum 3 per invocation. Each patch contains:
   - **Where**: section heading and approximate line range.
   - **Current text**: a short excerpt of what's there now (or "missing — proposed new bullet under X").
   - **Proposed text**: the exact replacement.
   - **Why**: one sentence tying the patch to a real failure or gap.
5. **Bump version and date.** In the proposed patch, also raise `version` by one patch increment (`0.1.0` → `0.1.1`) and set `last_updated` to today.
6. **Output as a single markdown block.** Do not modify the file. Present the patch and stop.

## Output format

```markdown
## Proposed patches for `<skill-name>` (v<current> → v<new>)

### Patch 1 — <one-line label>

**Where:** `## <section heading>`, around the bullet "...".

**Current text:**
> <short excerpt>

**Proposed text:**
> <exact replacement>

**Why:** <one sentence tied to a concrete failure or gap>.

### Patch 2 — ...
### Patch 3 — ...

---

To apply: open the file in your editor, make the changes, bump `version` to <new>, and set `last_updated` to <today>.
```

## Hard rules

- **Never auto-apply.** Output is proposal only. User applies via Edit. Stops silent degradation.
- **No restructuring.** Don't reshape sections, rename headings, or rewrite the skill philosophy. Only tweaks within existing sections.
- **Maximum 3 patches per invocation.** Avoid avalanche change. If more than 3 are warranted, list the rest as "deferred candidates" without details.
- **Patch specificity.** Vague suggestions like "be more rigorous" are forbidden. Every patch must propose exact replacement text.
- **Version bump.** Patch increment only (`0.1.0 → 0.1.1`). Minor or major bumps require a separate human decision.
- **Honesty about uncertainty.** If a sample is too short to support a patch, say so and stop. Don't invent a problem to justify a change.

## When NOT to invoke

- After a single trial run with no real friction (nothing to learn from).
- When the user's complaint is about model behaviour, not skill instructions (the skill is fine; the model needs a different sample).
- When the proposed change is structural (move sections, rename skill, split into two). Those are explicit design decisions, not patches.

## Companion: evals folder

Every skill should have an `evals/` sibling folder with a README and 3 to 4 case files. See `shared-base/skills/enhance-last-skill/evals/README.md` for the canonical format. Patches proposed by this skill should mention which eval case they would help pass, when relevant.

---

*Origin: codifies the Marchese "prompt the skill, not Claude" pattern as a first-class shared utility 2026-05-18.*
