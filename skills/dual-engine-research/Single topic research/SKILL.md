---
name: dual-engine-research
description: >
  Dual-Engine Research v1.2. Orchestrates topic research across two
  complementary engines: Perplexity (breadth, recency, citation density)
  and ChatGPT Deep Research (depth, reasoning, structural analysis).
  Takes a topic, timeframe, and initial angle from the user, produces
  two purpose-built prompts designed to return non-overlapping outputs,
  then synthesises the returned material into a single explanatory
  brief. Analytical and educational use only: explain a topic, map its
  dynamics, surface the angles. Not for investment-committee work; use a
  separate SKILL for that. Load when the user wants structured
  intelligence on any topic.
owner: William Bowdler-Raynar
version: 1.2.0
created: '2026-05-26'
last_updated: '2026-05-26'
status: draft
---

# Dual-Engine Research v1.2

A lightweight research orchestration SKILL. Two engines, three steps, one synthesis. Topic-agnostic, analytical register only. No theme lock-in, no scoring rubric, no schema overhead. Designed for the way William actually works: research a topic in depth using two complementary LLM tools, then collapse the output into something usable.

The goal is intelligence on a topic: explain it, map the dynamics, surface the angles. Not a decision document.

---

## 1. WHEN TO LOAD

Load when William wants to:

- Understand a new topic from a cold start (technical, conceptual, market structure, policy, anything).
- Map the dynamics of an area before committing time to deeper work.
- Produce a structured explainer with sources for a memo, a meeting, or for William's own reference.

Do NOT load for:

- Investment-committee or thesis work (use the dedicated investment SKILL).
- Cape Moonshot research (use `cape-moonshot-research-playbook`).
- Quick factual lookups (just answer directly).
- Coding or technical-build tasks (wrong tool).

---

## 2. THE THREE STEPS

```
1. INTAKE        →  Clarify topic, timeframe, angle.
2. PROMPT BUILD  →  Generate one Perplexity prompt and one ChatGPT
                    Deep Research prompt. Engines do different work;
                    prompts enforce the split.
3. SYNTHESIS     →  Take both returned outputs. Cross-reference, surface
                    conflicts, distinguish fact / consensus / signal,
                    produce one structured explainer.
```

User runs the two prompts in their own browser sessions and pastes the outputs back. Claude does Step 1, Step 2, and Step 3.

---

## 3. STEP 1 — INTAKE

The user provides, or is asked for, three fields:

1. **Topic** — what is being researched. As specific as possible. "LLM token pricing models across providers" is better than "tokens".
2. **Timeframe** — current state only, or current + forward look. If forward, how far (12 months, 3 years, 5 years).
3. **Angle** — 1–3 bullets on what the user wants to understand, what they don't know yet, or what they suspect. Can be "I don't have one yet, explain it to me".

If any of the three is missing or so vague the prompts can't be built, ask once. One clarification round, not a list. Otherwise proceed straight to Step 2.

---

## 4. STEP 2 — PROMPT BUILD

Two prompts. Each engine gets the work it's actually good at. No overlap by design; overlap is wasted budget.

### 4.1 Division of labour

| Engine | Best at | Assigned scope |
|---|---|---|
| **Perplexity** | Live web, citation density, named sources, recent data points, current pricing / specs, who-said-what | Current state. Named players. Numbers with sources. Recent developments. The "what is happening right now" layer. |
| **ChatGPT Deep Research** | Multi-step reasoning, structural analysis, mechanism walk-through, comparing approaches, forward view | Structural. How the thing works. Why it is shaped the way it is. Trade-offs between approaches. What could change. The "why and what next" layer. |

The split is by **type of question**, not by topic area. Both engines see the same topic; they answer different questions about it.

### 4.2 Perplexity prompt template

Substitute `[TOPIC]`, `[TIMEFRAME]`, `[ANGLE]`, `[DATE]` before pasting.

```
PERPLEXITY DEEP RESEARCH — [TOPIC]
Date: [DATE]
Timeframe: [TIMEFRAME]

USER ANGLE (what they want to understand):
[ANGLE bullets verbatim]

You are a senior research analyst producing a factual sweep on [TOPIC].
Focus on the CURRENT STATE layer. Pair-skill ChatGPT Deep Research is
handling structural and reasoning work separately; do not duplicate
that. Your job is breadth, recency, named sources, and numbers.

Return findings under these seven headings. Use bullet points within
each. Cite every numeric or named claim with an inline source URL.

1. WHAT IT IS — A precise definition in 4–6 sentences. If the topic
   has multiple credible definitions or scopes, list them and flag the
   difference.

2. CURRENT STATE — The 5–10 most important data points right now.
   Numbers, prices, specs, counts, dates. Each with year and URL.

3. KEY PLAYERS — Top 10 named entities (companies, products,
   institutions, providers, frameworks — whatever fits the topic).
   For each: one-line role, one differentiator, one URL.

4. NUMBERS AND SPECIFICATIONS — All quantitative material relevant to
   the topic. For [TOPIC] this means: [SPECIFIC NUMERIC TARGETS,
   tailored per topic at build time]. Give ranges where the market
   varies. Year and source for every figure.

5. RECENT DEVELOPMENTS (last 90 days) — Material news, launches,
   policy moves, price changes, technical releases. Date + one-line
   + URL.

6. NARRATIVE — How is this topic being discussed in credible press,
   provider docs, and practitioner communities right now? Building,
   fading, contested, consensus? 3–5 sentences with representative
   source URLs.

7. OPEN QUESTIONS — Three to five questions where the public record
   is thin, contradictory, or absent. These will be passed to the
   reasoning engine.

SOURCE STANDARDS
- Tier 1: primary documents (provider docs, official spec pages,
  regulatory filings, company disclosures, pricing pages),
  peer-reviewed, top trade press.
- Tier 2: established analyst and consulting houses (McKinsey, BCG,
  Gartner, IDC), tier-1 financial and tech press.
- Tier 3: practitioner blogs, industry forums, Substack — useful for
  recency but tag as such.
- Aim for 15+ distinct sources. No single source anchors more than
  three claims.
- Where two reputable sources disagree, show both with the
  disagreement explicit.

OUTPUT RULES
- Distinguish: (a) confirmed fact, (b) widely-cited consensus, (c)
  emerging signal. Tag each material claim.
- No essay prose. Headings, bullets, citations.
- If a figure is not available, write "UNKNOWN — public record thin"
  rather than inventing or estimating.
- Plain English. No em dashes.

Save as: Perplexity_[TOPIC short].txt
```

### 4.3 ChatGPT Deep Research prompt template

This template applies the v3 framing fix. Background: when a structured prompt is long, ChatGPT's interface silently converts the pasted text into an attached file (typically `Pasted text(N).txt`). Deep Research then defaults to "review the attached document" mode and produces a file-metadata table, a section-by-section summary of the brief, a fact-check of the brief, and a "recommended next steps" list, instead of executing the research.

The v2 fix (lead with an imperative verb, end with "do not produce a methodology essay") addressed a different failure mode (workflow essays) and does not prevent the file-review failure. The v3 framing below combines both guards.

Five rules applied:

1. The first line must explicitly tell Deep Research to ignore the attached-file framing if the interface has applied one.
2. The forbidden-output list sits at the TOP of the prompt, not the bottom. Deep Research weights early tokens heavily.
3. No "pair-skill" or "pair-engine" meta talk. That phrasing primes meta output. Describe the scope split as a plain scope statement.
4. The first deliverable section is anchored with a literal opening phrase ("Begin your output with the exact heading '1. BOTTOM LINE'"). This forces an execution commitment.
5. No "Save as" instruction inside the prompt. Naming a target filename reinforces the "this is an attached document" reading.

Substitute `[TOPIC]`, `[TIMEFRAME]`, `[ANGLE]`, `[DATE]`, `[AUDIENCE]` before pasting.

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

Produce a new explainer document with the eight numbered sections
below. Begin your output with the exact heading "1. BOTTOM LINE" and
write the explainer directly. Every figure carries a year and a source
URL.

Scope split: a separate breadth pass (current pricing, named players,
recent data points with citations) is being handled elsewhere. Your
job is structure, mechanism, reasoning, and forward view. Go deep on
the eight sections below.

USER ANGLE (what they want to understand):
[ANGLE bullets verbatim]

1. BOTTOM LINE. Five sentences. What [TOPIC] is in plain English, why
   it matters, and the single most important thing someone learning
   this should understand.

2. HOW IT WORKS. Mechanism, structure, the chain from inputs to
   outputs. One short paragraph per node. If there are competing
   technical or conceptual models, lay them out.

3. WHY IT IS SHAPED THE WAY IT IS. The underlying drivers. The
   engineering constraint, economic logic, regulatory regime, or
   historical accident that produced the current state. The single
   variable that, if it changed, would change everything else.

4. APPROACHES AND MODELS. The 3 to 6 distinct approaches in the
   field. For each: who uses it, what trade-offs it makes, when it
   wins, when it loses. Compare on the single dimension that matters
   most to someone trying to understand the topic.

5. TRADE-OFFS AND LEVERS. The decisions a practitioner makes within
   this topic and the trade-offs each one carries. For cost-sensitive
   topics: how to reduce cost and what is lost in doing so. For
   performance-sensitive topics: how to increase performance and what
   is paid for it. For policy topics: the levers regulators have and
   the second-order effects.

6. WHAT COULD CHANGE. Forward look over [TIMEFRAME]. The 3 to 5
   developments most likely to shift the topic materially. Be
   concrete: events, dates, named actors, observable signals.

7. COMMON MISCONCEPTIONS. Three to five things people get wrong
   about [TOPIC], with the correction and why the misconception
   persists.

8. WHAT I DON'T KNOW. Three to five honest gaps where the public
   record is thin or contradictory.

OUTPUT RULES
- Tag each material claim: (a) confirmed fact, (b) widely-cited
  consensus, (c) emerging signal.
- Minimum 20 high-quality sources with URLs.
- Where sources conflict, surface the conflict and which view you
  lean toward, with reasoning.
- Plain prose. Short paragraphs. No bullet padding. No em dashes.
- Begin the output with the exact heading "1. BOTTOM LINE" and
  proceed through all eight sections in order. Do not preface with
  a summary of the task or a confirmation of the instructions.
```

### 4.4 Per-topic tailoring

Before pasting the prompts to the user, Claude tailors four lines:

1. **Perplexity section 4** ("NUMBERS AND SPECIFICATIONS") — replace `[SPECIFIC NUMERIC TARGETS]` with the figures actually relevant to the topic. For LLM token pricing: input price per million tokens, output price per million tokens, context window size, free-tier limits, subscription tiers and inclusions. For a different topic, different targets.
2. **ChatGPT `[AUDIENCE]`** — replace with the actual audience (e.g. "a non-technical professional audience (family-office colleagues)", "an investment committee", "internal engineering team"). The audience phrase shapes register.
3. **ChatGPT section 4** ("APPROACHES AND MODELS") — if the topic has obvious categories (e.g. for LLM pricing: pay-per-token API, flat-rate subscription, hybrid, free with limits, self-hosted open-weight, inference-as-a-service, cloud-reseller), seed them as the starting set.
4. **ChatGPT section 6** ("WHAT COULD CHANGE") — pre-seed with known forward developments if any are obvious (e.g. for LLM tokens: model efficiency curves, open-weight displacement, prompt caching adoption, batch / async pricing growth, regulatory pricing pressure).

Tailoring is light. The prompts work without it; tailoring makes them sharper.

---

## 5. STEP 3 — SYNTHESIS

User pastes both outputs back. Claude produces a single brief.

### 5.1 Synthesis structure

```
1. BOTTOM LINE (5 sentences max)
   What [TOPIC] is. Why it matters. The one thing that matters most
   for understanding it.

2. WHAT BOTH ENGINES AGREE ON
   The convergent core. High confidence. Brief.

3. WHERE THEY DISAGREE (or where one has it and the other doesn't)
   The real signal. Surface every meaningful conflict. For each:
   - What Perplexity returned
   - What ChatGPT returned
   - Which is more credible and why (source quality, recency,
     methodology)
   - Whether the gap can be resolved, or needs a third source

4. HOW IT WORKS
   The mechanism, grounded in named players and numbers. Pull the
   structural walk-through from ChatGPT, anchor it with the current
   data points from Perplexity. Three to six short paragraphs.

5. THE LANDSCAPE
   Key players, approaches, numbers. Compressed map of who does what,
   how it differs, and what it costs or delivers.

6. DYNAMICS AND TRADE-OFFS
   The levers and the trade-offs each one carries. What a practitioner
   or observer should pay attention to.

7. FORWARD VIEW
   What changes over [TIMEFRAME]. Concrete signals, named events,
   observable triggers. No vague "watch this space".

8. MISCONCEPTIONS AND OPEN QUESTIONS
   What people get wrong, plus the union of both engines' "what I
   don't know" sections. Open questions ranked by how much they
   matter for understanding the topic.

9. SOURCES
   Combined list. Tier 1 first. One-line description per source and
   which section it informed.
```

### 5.2 Synthesis discipline

For every claim in the brief:

1. **Cross-reference both engines.** If they agree, state the value with the stronger primary source.
2. **If they disagree, surface the conflict.** Pick the more credible value, note the alternative.
3. **Tag the basis.** Confirmed fact / widely-cited consensus / emerging signal.
4. **Apply William's style.** Plain English, direct verbs, no em dashes, no banned phrases (meticulous, navigating complexities, realm, towards, robust, ever-evolving, daunting, in the heart of, when it comes to, etc.; full list in `00-shared-base.md`). Every sentence adds information.
5. **Bottom line first.** Core signal early. Reasoning after.

### 5.3 Detecting and re-running a ChatGPT meta-failure

A ChatGPT output should be inspected before it goes into synthesis. If any of the following are present, the engine failed and the prompt must be re-run with the v3 template above:

- A heading or section labelled "review", "audit", "assessment of the file", or "file identification".
- A metadata table listing filename, MIME type, byte size, line endings, encoding, or word count of the input.
- A diagram or table that summarises the input prompt's own structure.
- A section labelled "ambiguities, gaps, and recommended next steps" or similar that critiques the brief.
- An opening paragraph that begins "The attachment is...", "The attached file...", or "This brief commissions...".

If a meta-failure is detected, do not attempt to extract usable content from it. Re-run with the v3 template. Synthesis can then proceed normally.

### 5.4 What synthesis is NOT

- Not a re-paste of both engine outputs side by side. Claude does the work.
- Not a balanced summary. Claude has a view on which engine is more credible per claim, and shows it.
- Not vague. Numbers carry years and sources. "Around USD 20bn" without methodology is rejected.
- Not padded. Five strong sentences beat fifteen weak ones.

---

## 6. WORKED EXAMPLE — LLM tokens

To make the pattern concrete, here is how the intake and prompt build would run for William's stated topic.

**Intake**

- Topic: LLM tokens — what they are, how providers price them, the dominant pricing models (subscription / pay-as-you-go / hybrid / self-hosted), the forward path on price and efficiency, and practical levers to minimise token spend.
- Timeframe: current state + 12-month forward look.
- Angle: explain the topic end to end, map the dynamics across providers, surface where the cost levers actually sit.

**Tailoring**

- Perplexity section 4 numeric targets: input price per million tokens (current rates across OpenAI, Anthropic, Google, Mistral, xAI, DeepSeek), output price per million tokens, context window in tokens, prompt-cache pricing where offered, batch / async pricing, subscription tier names and monthly cost (Plus, Pro, Team, Enterprise), free-tier rate limits, self-hosted USD per million tokens benchmarks.
- ChatGPT `[AUDIENCE]`: "a non-technical professional audience (family-office colleagues)".
- ChatGPT section 4 seed categories: pay-per-token API, flat-rate subscription with quota, hybrid (subscription + overage), free with rate limits, self-hosted open-weight, inference-as-a-service for open-weight models, cloud-reseller channels.
- ChatGPT section 6 forward seeds: model efficiency curves (smaller models hitting bigger-model quality), open-weight displacement at the commodity tier, prompt-caching adoption, batch / async pricing growth, regulatory pricing transparency pressure.

**Then** Claude pastes the two tailored prompts. William runs them. William pastes outputs back. Claude synthesises.

---

## 7. QUALITY CONTROL

**Good output:**
- Two prompts built, each with the right scope, no overlap, tailored to the topic.
- ChatGPT prompt opens with the v3 framing block (anti-attachment guard, forbidden-output list, "Begin your output with..." anchor).
- Synthesis leads with bottom line, surfaces conflicts honestly, distinguishes fact / consensus / signal, ends with what to monitor.
- Numbers carry years and URLs.
- Voice matches William's style guide.

**Bad output:**
- Two prompts that ask the same questions in different words.
- ChatGPT prompt missing the v3 anti-attachment guards (file-review failure mode returns).
- Engine output that is a file review (metadata table, structural diagram of the prompt, fact-check of the brief, "recommended next steps" on the brief itself) accepted into synthesis rather than re-run.
- Synthesis that is a both-sides summary with no view.
- Vague conclusions, undated figures, missing sources.
- Hedge words, banned phrases, em dashes.
- More than one clarifying question at intake.

---

## 8. CHANGELOG

**v1.2** (2026-05-26, draft)
- Hardened the ChatGPT Deep Research template against the attached-file failure mode. ChatGPT's interface silently converts long pasted prompts into an attached file, after which Deep Research defaults to reviewing the file rather than executing it (file-metadata table, structural diagram of the prompt, section-by-section summary, fact-check of the brief's claims, "recommended next steps" on the brief itself). The v2 fix targeted methodology essays and did not catch this.
- v3 framing applied: (a) first line tells Deep Research to ignore attached-file framing if applied by the interface, (b) forbidden-output list moved to the top of the prompt, (c) "pair-skill" meta talk removed, (d) first deliverable section anchored with a literal opening phrase ("Begin your output with the exact heading '1. BOTTOM LINE'"), (e) "Save as" line removed from inside the prompt.
- Added `[AUDIENCE]` as an explicit tailoring slot in the ChatGPT template.
- Added §5.3 "Detecting and re-running a ChatGPT meta-failure" with diagnostic markers and a re-run rule.
- Added the file-review failure to the Bad-output list in §7.
- Renumbered §5.3 ("What synthesis is NOT") to §5.4.

**v1.1** (2026-05-26, draft)
- Dropped the Comet framing. Perplexity is the engine, the browser is incidental.
- Removed the Analytical / Investment register flag. SKILL is analytical and educational only; investment-committee work belongs to a separate SKILL.
- Retuned both prompts to explain, map, and surface angles rather than support a decision. Renamed Perplexity §4 from "Pricing / Economics / Numbers" to "Numbers and Specifications". Replaced ChatGPT §5 ("How to act on it") with "Trade-offs and levers". Replaced ChatGPT §7 ("Bear case / disconfirming evidence") with "Common misconceptions".
- Synthesis structure retuned: removed "practical takeaway" and "bear case" sections; added "Dynamics and trade-offs" and "Misconceptions and open questions".

**v1.0** (2026-05-26, draft)
- Initial build. Two-engine pattern (Perplexity / Comet + ChatGPT Deep Research). Three steps (intake / prompt build / synthesis). Topic-agnostic with Analytical / Investment register flag. Inherited the v2 ChatGPT prompt-framing fix from `cape-moonshot-research-playbook` v1.1 to prevent Deep Research returning a methodology essay.
