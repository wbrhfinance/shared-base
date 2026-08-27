---
name: dual-engine-research
description: >
  Multi-Engine Research v2.0 (formerly Dual-Engine Research). Orchestrates
  topic research across four engines: ChatGPT (structural reasoning),
  Perplexity (breadth, recency, citations, run on a non-OpenAI model),
  Grok (real-time X-platform pulse), and Quartr (company- and sector-level
  primary evidence, gated on investment aspect). Claude asks a five-field
  intake, builds one tailored prompt per engine, runs each engine directly
  in the user's own authenticated browser sessions via Claude in Chrome,
  collects the outputs, and produces a long and a short synthesis with no
  repetition. Saves everything to a per-topic folder under Cape Capital's
  Themes directory. Analytical and educational register: explain a topic,
  map its dynamics, surface the angles. Load when William wants structured,
  multi-source intelligence on a topic.
owner: William Bowdler-Raynar
firm: shared
version: 2.0.0
status: draft
agnostic: true
created: '2026-05-26'
last_updated: '2026-08-12'
last_used:
usage_count: 0
---

# Multi-Engine Research v2.0

*(formerly "Dual-Engine Research" — kept the same skill name for continuity; the pattern has grown from two engines to four.)*

Four engines, one intake, one execution pass, one synthesis. Topic-agnostic, analytical register only. Designed for the way William actually works: research a topic using several complementary tools, then collapse everything into something short enough to act on.

The goal is intelligence on a topic: explain it, map the dynamics, surface the angles, and — only when asked — name the companies exposed to it. Not a decision document on its own.

The big change from v1: Claude no longer hands the user two prompts to paste into separate browser tabs and waits for pasted-back output. Claude now drives the browser sessions directly (Claude in Chrome), submits the prompts itself into the user's already-logged-in ChatGPT, Perplexity, Grok, and Quartr accounts, reads the responses back, and writes the files. The user does the intake and the review; Claude does the running-around.

---

## 1. WHEN TO LOAD

Load when William wants to:

- Understand a new topic from a cold start (technical, conceptual, market structure, policy, thematic).
- Map the dynamics of an area before committing time to deeper work.
- Get a fast read on what's being said about a topic on X, alongside the structured research.
- Check whether specific listed companies have real exposure to a topic, backed by their own filings and earnings calls.
- Produce a structured explainer, long and short, for a memo, a meeting, or his own reference — filed under Cape Capital's Themes.

Do NOT load for:

- Full investment-committee thesis work with a scored rubric (use the dedicated investment SKILL).
- Cape Moonshot research (use `cape-moonshot-research-playbook`).
- Quick factual lookups (just answer directly).
- Coding or technical-build tasks (wrong tool).

---

## 2. THE FOUR STEPS

```
1. INTAKE      →  Five fields: topic, context, core question, time period,
                  investment aspect (companies in or out).
2. PROMPT BUILD →  One tailored prompt per engine in play. No two engines
                  asked the same question the same way.
3. EXECUTION    →  Claude runs every prompt directly in the user's own
                  logged-in browser sessions, reads back the output,
                  saves each as a raw file.
4. SYNTHESIS    →  Cross-reference everything collected. Surface
                  agreement, conflict, and social-media noise separately.
                  Produce a long and a short brief. Save both, plus the
                  raw outputs, to the topic's folder.
```

---

## 3. STEP 1 — INTAKE

Ask for all five fields in a single message. One clarification round if something is missing or too vague to build prompts from — never a list of follow-up questions across multiple turns.

1. **Topic** — what is being researched, as specific as possible. "Tungsten supply chain and China export controls" beats "tungsten".
2. **Context** — why this matters right now. What prompted the question, what William already knows, what he's reacting to.
3. **Core question** — the single question this research needs to answer. Not "explain tungsten" but "does the China export-control tightening create an investable supply squeeze, and for how long."
4. **Time period** — the look-back cutoff (how far back is still relevant, e.g. "nothing before 2023 export-control regime") and the forward horizon if any (12 months, 3 years).
5. **Investment aspect** — include companies as an output at this stage, yes or no. This single answer gates Quartr (§4.5) and whether the ChatGPT/Perplexity prompts are told to surface named listed players.

If investment aspect is "yes" but William already has specific tickers in mind, capture them now — it saves a round trip before Quartr can run.

---

## 4. STEP 2 — PROMPT BUILD

Each engine gets the work it is actually good at. No two prompts ask the same question in different words; overlap is wasted budget and wasted synthesis effort.

### 4.1 Division of labour

| Engine | Best at | Assigned scope | Always run? |
|---|---|---|---|
| **ChatGPT** | Multi-step reasoning, structural analysis, mechanism walk-through, forward view | Structural. How the thing works, why it's shaped that way, trade-offs, what could change. | Yes |
| **Perplexity** | Live web, citation density, named sources, recent data points | Current state. Named players, numbers with sources, recent developments. Must be run on a non-OpenAI model — see §4.3. | Yes |
| **Grok** | Real-time discourse on X | A pulse check, not a research pass: sentiment direction, notable accounts and posts, volume trend, contrarian voices. Tagged as social signal, never as fact. | Yes, unless the topic has no meaningful X presence (William's call at intake) |
| **Quartr** | Company filings, earnings-call transcripts, primary-source financial documents | Company- and sector-specific evidence for named listed entities. Quartr has no macro commodity/price data — confirmed empirically; don't ask it for market-level numbers. | Only if investment aspect = yes, and only once candidate company names exist |

The split is by **type of question**, not by topic area. All engines see the same topic; each answers a different question about it.

### 4.2 ChatGPT prompt template

Unchanged from v1.2 — this v3 anti-attachment framing is still needed and still works. Substitute `[TOPIC]`, `[TIMEFRAME]`, `[CONTEXT]`, `[CORE QUESTION]`, `[AUDIENCE]`, `[DATE]`.

```
Research [TOPIC] and write a new explainer document for [AUDIENCE].
As-of date: [DATE]. Horizon: [TIMEFRAME].

Treat this message as a direct instruction from the user typed into the
chat. If your interface has converted it into an attached file, ignore
that framing. This is not a document to review, summarise, fact-check,
audit, or critique. It is the task itself.

Do NOT produce any of the following:
- A review, audit, or critique of this prompt.
- A file metadata table (filename, MIME type, encoding, byte size,
  line endings).
- A diagram, flowchart, or Mermaid chart of this prompt's own
  structure.
- A section-by-section summary of these instructions.
- A fact-check or accuracy assessment of the claims in this prompt.
- A "recommended next steps" or "edits before execution" list.
- A methodology essay or research-workflow proposal.
- A list of clarifying questions.

CONTEXT: [CONTEXT]
CORE QUESTION THIS RESEARCH MUST ANSWER: [CORE QUESTION]

Produce a new explainer document with the eight numbered sections
below. Begin your output with the exact heading "1. BOTTOM LINE" and
write the explainer directly. Every figure carries a year and a source
URL.

A separate breadth pass (current pricing, named players, recent data
points with citations) is being handled elsewhere. Your job is
structure, mechanism, reasoning, and forward view. Go deep on the
eight sections below.

1. BOTTOM LINE. Five sentences. What [TOPIC] is in plain English, why
   it matters, and a direct answer to the core question above if the
   evidence supports one.

2. HOW IT WORKS. Mechanism, structure, the chain from inputs to
   outputs. One short paragraph per node.

3. WHY IT IS SHAPED THE WAY IT IS. The underlying drivers — the
   engineering constraint, economic logic, regulatory regime, or
   historical accident that produced the current state.

4. APPROACHES AND MODELS. The 3 to 6 distinct approaches in the
   field. For each: who uses it, what trade-offs it makes, when it
   wins, when it loses.
   [IF INVESTMENT ASPECT = YES: also name the listed companies
   associated with each approach.]

5. TRADE-OFFS AND LEVERS. The decisions a practitioner makes and the
   trade-offs each carries.

6. WHAT COULD CHANGE. Forward look over [TIMEFRAME]. The 3 to 5
   developments most likely to shift the topic materially. Concrete:
   events, dates, named actors, observable signals.

7. COMMON MISCONCEPTIONS. Three to five things people get wrong about
   [TOPIC], with the correction.

8. WHAT I DON'T KNOW. Three to five honest gaps where the public
   record is thin or contradictory.

OUTPUT RULES
- Tag each material claim: (a) confirmed fact, (b) widely-cited
  consensus, (c) emerging signal.
- Minimum 20 high-quality sources with URLs.
- Plain prose. Short paragraphs. No bullet padding. No em dashes.
- Begin the output with the exact heading "1. BOTTOM LINE" and
  proceed through all eight sections in order.
```

### 4.3 Perplexity prompt template and model rule

Same seven-section structure as v1.2, with the core question folded in. Substitute `[TOPIC]`, `[TIMEFRAME]`, `[CONTEXT]`, `[CORE QUESTION]`, `[DATE]`.

```
PERPLEXITY DEEP RESEARCH — [TOPIC]
Date: [DATE]
Timeframe: [TIMEFRAME]

CONTEXT: [CONTEXT]
CORE QUESTION THIS RESEARCH MUST HELP ANSWER: [CORE QUESTION]

You are a senior research analyst producing a factual sweep on [TOPIC].
Focus on the CURRENT STATE layer. A separate reasoning pass is handling
structural and forward-looking work; do not duplicate that. Your job is
breadth, recency, named sources, and numbers.

Return findings under these seven headings. Bullet points within each.
Cite every numeric or named claim with an inline source URL.

1. WHAT IT IS — Precise definition, 4-6 sentences.
2. CURRENT STATE — 5-10 most important data points right now, each
   with year and URL.
3. KEY PLAYERS — Top 10 named entities. One-line role, one
   differentiator, one URL each.
   [IF INVESTMENT ASPECT = YES: flag which are publicly listed and
   their ticker.]
4. NUMBERS AND SPECIFICATIONS — [SPECIFIC NUMERIC TARGETS, tailored
   per topic]. Ranges where the market varies. Year and source for
   every figure.
5. RECENT DEVELOPMENTS (last 90 days) — date + one line + URL each.
6. NARRATIVE — How is this being discussed in credible press and
   practitioner communities right now? 3-5 sentences with sources.
7. OPEN QUESTIONS — 3-5 questions where the public record is thin or
   contradictory.

SOURCE STANDARDS
- Tier 1: primary documents, regulatory filings, company disclosures,
  peer-reviewed, top trade press.
- Tier 2: established analyst/consulting houses, tier-1 financial and
  tech press.
- Tier 3: practitioner blogs, forums — useful for recency, tag as such.
- Aim for 15+ distinct sources. No single source anchors more than
  three claims. Where two reputable sources disagree, show both.

OUTPUT RULES
- Tag each claim: (a) confirmed fact, (b) widely-cited consensus,
  (c) emerging signal.
- No essay prose. Headings, bullets, citations.
- If a figure is unavailable, write "UNKNOWN — public record thin"
  rather than estimating.
- Plain English. No em dashes.
```

**Model rule — non-negotiable.** Before submitting, set Perplexity's model selector to a non-OpenAI model. Perplexity's own default ("Best" / Sonar) is fine; Claude or Gemini also fine if offered. Never GPT-5, GPT-4o, o-series, or any other OpenAI-branded option. The point of running two engines is to get a second, independently-reasoned pass — if Perplexity is quietly answering on the same OpenAI model as ChatGPT, that independence is gone. Check the model dropdown every run; don't assume it held from last time.

### 4.4 Grok prompt template — X-platform pulse

New in v2.0. This is deliberately lighter than the other two. Grok's contribution is a social-signal snapshot, not a research deliverable — treat it that way at intake and at synthesis.

```
Quick pulse check on [TOPIC] — what's actually being discussed on X
right now, not a full research report.

CONTEXT: [CONTEXT]

Give me:
1. Overall sentiment direction (bullish / bearish / neutral / sharply
   contested) and roughly how strong.
2. The 3-5 most notable accounts or posts driving the conversation,
   with a one-line summary of each position.
3. Whether volume/attention on this topic is rising, falling, or flat
   over the last 1-2 weeks.
4. Any contrarian or minority view getting real traction, even if it's
   a small share of voice.

Keep it short. This is a sentiment snapshot, not an explainer — no
citations to formal sources needed, just what's actually on the
platform.
```

### 4.5 Quartr prompt template — company evidence

New in v2.0. Only run if investment aspect = yes. Requires named companies — either supplied by William at intake, or surfaced by the ChatGPT/Perplexity passes first (in which case run Quartr as a second wave, after those two return).

Do not ask Quartr for macro commodity, price, or market-size data — confirmed empirically that it doesn't hold this and will correctly decline. Ask it about companies by name.

```
For [COMPANY NAME(S)], pull the most recent earnings-call commentary,
management guidance, and filings that touch on [TOPIC].

Specifically:
1. Has management discussed [TOPIC] on recent calls? Direct quotes
   where possible, with call date.
2. What guidance or forward commentary exists on exposure to [TOPIC]
   (revenue exposure, cost exposure, strategic response)?
3. Any filing disclosures (risk factors, segment reporting) that
   quantify the exposure?

If a named company has no material disclosed exposure, say so plainly
rather than stretching a tangential mention.
```

If Quartr's first response declines because the topic is too macro (as it will for anything without a company name attached), that is not a failure — it is Quartr correctly staying in its lane. Feed it names, not markets.

### 4.6 Per-topic tailoring

Before running the prompts, Claude tailors:

1. **Perplexity §4** — replace `[SPECIFIC NUMERIC TARGETS]` with the figures actually relevant to the topic.
2. **ChatGPT `[AUDIENCE]`** — usually "William, a family-office / wealth-management professional" unless a different audience is stated.
3. **ChatGPT §4** — seed the 3-6 approach categories if the topic has obvious ones.
4. **ChatGPT §6** — pre-seed known forward developments if any are obvious.
5. **Quartr company list** — from intake if supplied, otherwise pulled from the Perplexity/ChatGPT "key players" sections once those return.

Tailoring is light. The prompts work without it; tailoring makes them sharper.

---

## 5. STEP 3 — EXECUTION (Claude runs it directly)

This replaces v1's "user pastes outputs back." Claude now has Claude in Chrome access to the user's own logged-in sessions and runs the pipeline end to end.

1. **Confirm the right account is live before running anything.** Check the visible plan/account indicator in each app's UI (sidebar, account menu) against what William expects. Flag any mismatch before running — don't silently proceed on the wrong tier or the wrong account. This happened once already (a Perplexity session came up on a free-plan account when William holds an Enterprise Pro subscription); a five-second screenshot check catches it.
2. **Set Perplexity's model per §4.3 before submitting.**
3. **Submit each prompt** in a fresh controlled tab. Run ChatGPT, Perplexity, and Grok in parallel (independent tabs); run Quartr second if it depends on names surfaced by the others.
4. **Wait for completion, then extract the response.** For plain chat UIs (ChatGPT, Perplexity, Grok, Quartr) the response is regular page DOM — read it directly rather than relying on screenshots for the text itself. Screenshot only to confirm state (loading, finished, error).
5. **Watch for the ChatGPT meta-failure** (file-review mode: a metadata table, a structural diagram of the prompt, a fact-check of the brief, an opening line like "The attachment is..."). If detected, re-run once automatically with the same v3 template rather than passing the failed output into synthesis.
6. **Stop and ask, never click through, on any consent/ToS/login gate.** If an engine shows an updated Terms of Service, a cookie banner beyond the standard decline, or an OAuth/SSO prompt, pause and ask William — this happened with Grok's ToS update and is exactly the kind of action that needs his say, not an assumption.
7. **Save each raw response** to `01 Output` in the topic folder (§6) before doing any synthesis work, so nothing is lost if a later step needs redoing.

---

## 6. STEP 4 — SYNTHESIS AND FILING

### 6.1 Folder structure

Create, under `C:\Users\willi\OneDrive\Business\Cape Capital\Themes\`:

```
<Topic name>/
├── 01 Output/
│   ├── ChatGPT_<topic short>.md
│   ├── Perplexity_<topic short>.md
│   ├── Grok_<topic short>.md
│   └── Quartr_<company>_<topic short>.md   (one per company, if run)
└── 02 Synthesize/
    ├── <Topic> - Claude Summary (Long).md
    └── <Topic> - Claude Summary (Short).md
```

This matches the convention already in use across other Themes folders (Custodian Cyber Risk, Hair Loss Treatment).

### 6.2 Synthesis structure — Long version

```
1. BOTTOM LINE (5 sentences max)
   What the topic is, why it matters, and a direct answer to the core
   question from intake if the evidence supports one.

2. WHAT THE ENGINES AGREE ON
   The convergent core across ChatGPT and Perplexity. High confidence.

3. WHERE THEY DISAGREE
   Every meaningful conflict between ChatGPT and Perplexity. For each:
   what each said, which is more credible and why, whether the gap
   resolves or needs a third source.

4. HOW IT WORKS
   Mechanism, grounded in named players and numbers. Structural
   walk-through from ChatGPT, anchored with current data from
   Perplexity.

5. THE LANDSCAPE
   Key players, approaches, numbers.

6. DYNAMICS AND TRADE-OFFS
   The levers and what each costs.

7. FORWARD VIEW
   What changes over the stated horizon. Concrete, named, dated.

8. PLATFORM X PULSE (only if Grok ran)
   Sentiment direction, notable voices, volume trend. Explicitly
   tagged as social signal, not fact — never merged into sections 2-7.

9. COMPANY EVIDENCE (only if investment aspect = yes and Quartr ran)
   Named companies, what their own disclosures and calls actually say
   about exposure to the topic. Flag where a company has no material
   exposure despite surface-level association.

10. MISCONCEPTIONS AND OPEN QUESTIONS
    What people get wrong, plus the union of every engine's stated
    gaps, ranked by how much each matters for the core question.

11. SOURCES
    Combined list, tier 1 first, one line each on what it informed.
```

### 6.3 Synthesis structure — Short version (max 1,000 words)

No section numbering, no jargon, no repetition of the long version's structure. Write it as five to eight short paragraphs:

- Direct answer to the core question, first sentence.
- What's solid (both engines agree, well-sourced).
- What's contested or uncertain, and why it matters.
- The one or two things most likely to change this over the stated horizon.
- If investment aspect = yes: the company-level read, one line per name, only where evidence actually supports a view.
- What to do with this — one concrete, actionable line. Not "monitor the situation"; something William could actually act on or decide.

Every sentence adds information. If a sentence could be deleted without losing anything, delete it.

### 6.4 Synthesis discipline

1. Cross-reference ChatGPT and Perplexity on every claim. Agreement → state with the stronger source. Disagreement → surface it, pick the more credible value, note the alternative.
2. Grok's output never gets treated as fact. It answers "what's the mood," not "what's true." Keep it in its own section.
3. Quartr's output is treated as primary evidence, weighted above secondary commentary from the other three, but only for the specific companies it covered — do not extrapolate a company's disclosed exposure onto the whole sector.
4. Tag every material claim: confirmed fact / widely-cited consensus / emerging signal.
5. Plain English, direct verbs, no em dashes, no banned phrases (meticulous, navigating complexities, realm, towards, underpins, ever-changing, ever-evolving, robust, daunting, in the heart of, when it comes to, amongst, unlock the secrets, not only, designed to enhance, it is advisable — full list in `00-shared-base.md`).
6. Bottom line first, always.
7. No repetition between the long and short versions in phrasing — the short version is a distinct, compressed pass, not a trimmed copy-paste of the long one's opening sections.

---

## 7. QUALITY CONTROL

**Good output:**
- Four (or three, if Grok is skipped, or fewer if investment aspect = no) prompts built, each scoped to what that engine is actually good at, none overlapping.
- Perplexity confirmed running on a non-OpenAI model before submission.
- Account/plan mismatch checked and flagged before running, not after.
- Any consent/ToS gate stopped on and asked about, never clicked through.
- ChatGPT meta-failure caught and re-run automatically.
- Long synthesis keeps Grok and Quartr in their own tagged sections, never blended into the fact layer.
- Short synthesis under 1,000 words, no jargon, one actionable line.
- Files land in the correct topic folder under Themes, in the `01 Output` / `02 Synthesize` structure.

**Bad output:**
- Two prompts asking the same question in different words.
- Perplexity run on GPT-5 or another OpenAI model without noticing.
- X sentiment presented as fact in the main synthesis.
- Quartr asked for macro/commodity data instead of company evidence.
- A ToS or login gate clicked through without asking.
- Short version over 1,000 words, or just a shortened copy of the long version.
- Files saved outside the topic folder, or the folder name doesn't match the topic.
- Hedge words, banned phrases, em dashes, more than one clarification round at intake.

---

## 8. CHANGELOG

**v2.0** (2026-08-12)
- Consolidated the two parallel copies of this skill (root `SKILL.md` v1.1 and `Single topic research/SKILL.md` v1.2) into one canonical file. The subfolder copy is superseded — see the pointer left in its place.
- Expanded from two engines to four: added Grok (X-platform sentiment pulse) and Quartr (company/sector primary-source evidence, gated on investment aspect).
- Replaced the three-field intake (topic / timeframe / angle) with a five-field intake (topic / context / core question / time period / investment aspect). Investment aspect gates Quartr and whether named companies are requested from the other engines.
- Replaced the "user runs prompts in their own browser and pastes output back" execution model with direct execution: Claude runs every prompt itself via Claude in Chrome, in the user's already-authenticated sessions, and extracts the responses.
- Added the Perplexity non-OpenAI-model rule as a hard execution step, not just a preference.
- Added account/plan verification before running (learned from a live mismatch: a Perplexity session came up on a free-plan account when the subscription is Enterprise Pro).
- Added the consent/ToS/login-gate stop rule (learned from Grok prompting an updated ToS acceptance mid-run).
- Added a per-topic output-folder convention under Cape Capital's Themes directory (`01 Output` / `02 Synthesize`), matching the pattern already in use for other themes.
- Synthesis now produces two files, long and short, instead of one brief. Short version capped at 1,000 words, no jargon, ends on one actionable line.
- Retained the v1.2 ChatGPT v3 anti-attachment framing and meta-failure detection unchanged — still needed, still works.

**v1.2** (2026-05-26, draft, superseded)
- Hardened the ChatGPT Deep Research template against the attached-file failure mode (v3 framing: ignore-attachment line, forbidden-output list moved to top, no pair-skill meta talk, literal opening-heading anchor, no in-prompt "Save as").
- Added `[AUDIENCE]` as an explicit tailoring slot.
- Added meta-failure detection and re-run rule.

**v1.1** (2026-05-26, draft, superseded)
- Dropped the Comet framing. Removed the Analytical / Investment register flag — this SKILL stayed analytical/educational only until v2.0 added the gated investment-aspect field.
- Retuned prompts and synthesis structure to explain and map rather than support a decision.

**v1.0** (2026-05-26, draft, superseded)
- Initial build. Two-engine pattern (Perplexity + ChatGPT Deep Research). Three steps. Topic-agnostic.
