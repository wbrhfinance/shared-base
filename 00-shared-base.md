# William Bowdler-Raynar — Core Profile (00 Shared Base)

**Purpose.** Cross-firm personal layer. Loaded alongside any toolbox (`cape-toolbox`, `brh-toolbox`) to give Claude William's positioning, career, languages, and current allocation. Firm-specific context (brand, voice, mandate, team, typography) lives in each toolbox and is *not* duplicated here.

**Canonical path.** `C:\Users\willi\Code\shared-base\00-shared-base.md` (referenced by `cape-toolbox/CLAUDE.md` and `brh-toolbox/CLAUDE.md`). Lives in its own private repo `wbrhfinance/shared-base`.

Last updated: 2026-05-16. v2.

---

## Positioning

Senior investment professional, 38 years in the industry. 25 years at UBS Investment Bank (1987–2012), finishing as Desk Head, Global Family Office Group — Cross Asset Solutions, member of the Swiss FICC Executive Committee.

Core edge: building narratives around investable themes and companies, and using modern tooling as a force multiplier so one person operating part-time across multiple roles produces what would otherwise need a team. The Moonshots fund at Cape (built on his thematic research, AMC ISIN CH1496790390, best-performing fund YTD +25% to +30%) is the flagship proof point.

Treat William as a senior peer with deep capital markets foundations and an unusually advanced personal AI/web tooling stack. Not a developer; not learning the tools. Calibrate accordingly.

---

## Current allocation

| Role | Firm | Weight | Status |
|---|---|---|---|
| Thematic Content (Moonshots architect) | Cape Capital | **80%** | Active. Primary engagement. |
| Executive Board Member | B-R & H Finance SA | ~15% | Active. Family-linked firm (see note). |
| Partner | Investment Circle | low | On back burner. |
| Venture Partner | Beyond Impact VC | 0% | Terminated Dec 2025 to avoid liability without active involvement. |
| Investment Committee, no vote | Partisan Strategie Fonds | 0% | Ended Dec 2022. |

**Note on BRH.** Founded 2004 by Jonathan Bowdler-Raynar, William's only brother. William is an Executive Board Member from Mar 2022. Seventh-generation Swiss banking lineage (Hottinguer house heritage).

---

## Career foundation

- **UBS Investment Bank** — Managing Director, Nov 1987 – Dec 2012 (25 yrs). FICC, structured products, derivatives, asset & liability management. Final role: Desk Head, Global Family Office Group — Cross Asset Solutions. Member, Swiss FICC Executive Committee.
- **Banque Hottinger & Cie SA** — Head Investment Services & Strategy, Deputy CEO, Executive Board member, Jul 2014 – Jun 2017.
- **RBR Capital Advisors AG** — Board Member, Jul 2017 – Dec 2018. Activist campaigns (GAM, Credit Suisse).
- **Emerald Technology Ventures** — Senior Advisor to Emerald European Transformation Fund VIII (€250m), Apr 2022 – Nov 2022.

## Education

- **EBS Paris** (European Business School Paris), 1983–1987.
- Nothing else worth flagging.

## Languages

- **English** — fully fluent. Default for Cape outputs.
- **French** — fully fluent. Default for BRH outputs (BRH is French-first).
- **German** — below average. Do not draft in German without explicit request.

## Location

Risch-Rotkreuz, canton Zug, Switzerland.

---

## Tooling stack

- Claude — Cowork (primary surface for most work), Claude Code in VS Code (for code), Chrome extension, Excel and PowerPoint plugins. No full M365.
- VS Code + GitHub for all code.
- Bolt for some web builds (notably the BRH website, 90% done).
- Vercel for some deploys (cape_iran sentiment page).
- Azure from late May 2026 for Silicon Corner tools.
- The Cape and BRH toolboxes are already structured (skills, agents, runbooks, MCPs, assets). See `cape-toolbox/CLAUDE.md` and `brh-toolbox/CLAUDE.md` for the architecture.

Direction of travel: PowerPoint → web-based presentations; Excel dashboards → web-based dashboards; one-off prompts → composable skills.

---

## Where firm-specific context lives (do not duplicate here)

- **Cape Capital** — see `cape-toolbox/CLAUDE.md`. Includes brand, voice, source hierarchy, personas (CIO, IC, macro, equity, compliance, client-advisor), mandate exclusions, Moonshots framework, skills, agents, runbooks. The Moonshots research source data lives in OneDrive: `Cape Capital/Moonshots/` (universe construction, GICS, narrative, prompts).
- **B-R & H Finance** — see `brh-toolbox/CLAUDE.md`. Includes firm history, Jonathan-led portfolio philosophy, voice (FR-first), Les 4 Saisons newsletter system, market data workflow, typography (Swiss apostrophe), website design system.

---

## Voice (cross-firm)

Operational rules are in Cowork custom instructions (bottom line first, no em dash, banned phrases, etc.). Firm-specific voice rules live in each toolbox.

Cross-firm constants:
- Treat William as a thinking partner. Do not agree passively. Push back where the logic is weak.
- One strong draft, not a menu of options.
- At most one clarifying question, never a list.
- Match William's language (English by default; French if he writes in French).

---

## Open items for William

1. People — colleagues at Cape (Oscar handles equity screening/RBICS; Ludovico handles Python automation per the Cape CLAUDE.md). Add others Claude should know.
2. Moonshots methodology — deferred. Will be subject to a separate, more extensive pass.
