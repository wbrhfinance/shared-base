# Evals — canonical convention

This README defines the canonical format for `evals/` folders across every skill in cape-toolbox, brh-toolbox, and shared-base. Each skill carries its own `evals/` sibling folder with 3 to 4 case files.

Evals are **manual checklists** for now. The format is structured so it can later be parsed for automation without rewriting the cases.

---

## Folder layout

```
skills/<skill-name>/
├── SKILL.md
└── evals/
    ├── README.md        (optional, skill-specific notes)
    ├── case-01-<label>.md
    ├── case-02-<label>.md
    ├── case-03-<label>.md
    └── case-04-<label>.md
```

Case files are numbered `case-NN-<short-kebab-label>.md`. Numbering is for sort order, not priority.

## Required sections per case file

Every case `.md` file must contain four sections, in this order:

### 1. Input

What the skill was given. A description of the input artefact (document, podcast, ticker, brief). Include enough detail to reproduce or at least recognise the case. Example: "30-minute a16z episode on agentic AI infrastructure, with Eric Schmidt as guest."

### 2. Expected qualities

A bulleted list of qualitative criteria the output should meet. Each bullet is a "must" or "must avoid." Example:

- Must include the full header block (Podcast, Host, Guest, Date, Length, Language, Link).
- Must define every abbreviation on first use.
- Must end with a forward-looking sentence naming the single most important factor to watch.
- Must avoid biographical filler about the guest.

### 3. Acceptance criteria

A pass / fail rule set. Quantitative or boolean where possible. Example:

- Word count: 150 to 250 (inclusive). **Pass / Fail.**
- Header block: all 7 fields present. **Pass / Fail.**
- At least 2 quantified data points cited with bracketed `[number]` references. **Pass / Fail.**
- Skill considered passing for this case when all the above resolve to Pass.

### 4. Notes / known issues *(optional)*

Free-text section for context: previous failures, edge cases, comparison points. Skip if not needed.

---

## How to use

**Manual review (today).** When a skill outputs something, run through the case file that most closely matches the input and tick each acceptance criterion. If anything fails, that's a candidate input to `enhance-last-skill`.

**Stability marker.** A skill is considered **stable** once every case in its `evals/` passes in a single run. Mark this in the skill's `SKILL.md` frontmatter by setting `status: stable` (or moving from `active` to `stable`). Reverts to `active` if a case fails on later use.

**Future automation.** The structured sections (Input / Expected qualities / Acceptance criteria) are designed to be machine-parseable. A future runner would read each case, invoke the skill, and compare against acceptance criteria. Don't optimise for that now; write cases as if for a thoughtful human reviewer.

---

## Case authorship rules

- 3 to 4 cases per skill is the floor. More is fine, but every case is maintenance.
- Cover diversity: short and long inputs, different domains, both languages where relevant, edge cases.
- Acceptance criteria should be falsifiable. "Output is good" is not a criterion. "Output is between 150 and 250 words" is.
- Reference real artefacts where possible (a known podcast episode, a specific deck) so the case can be reproduced.
- Don't bake in vendor specifics that will rot ("uses GPT-5"). Test the skill's intent, not the runtime.

---

*This README is the source of truth. Any skill-specific eval README under a particular skill's folder is allowed to add detail but must not contradict this convention.*
