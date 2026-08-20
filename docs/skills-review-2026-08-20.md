# Skills inventory & cull sheet — 2026-08-20

40 skill folders across three repos. Most untouched since the 2026-05-18 migration.
Mark the Verdict column (keep / merge / archive / delete) and hand it back; I'll execute.

My recommendations are pre-filled. "Archive" = move to the repo's `archive/` folder,
out of Claude's skill-loading path but still versioned.

## shared-base (5 skills)

| Skill | Purpose (from its own description) | Last activity | Recommendation |
|---|---|---|---|
| dual-engine-research | Multi-Engine Research v2.0: orchestrates topic research across ChatGPT, Perplexity, Grok, Claude | today | **Keep** — actively maintained |
| └ Single topic research | Now a 704-byte stub after today's slim-down; folder still holds `art-market-prompts.md` (work product) | today | **Merge into parent** — move art-market-prompts to OneDrive Themes alongside Tokens, delete subfolder |
| enhance-last-skill | Feedback loop: reviews a skill against a real session, proposes patches | 2026-05-18 | **Keep** — meta-tool, cheap to hold |
| fred-api | FRED API integration guide for macro data | 2026-07-01 | **Keep** — used by brh-demo data layer |
| security-auditor | Safety verdicts on npm/PyPI/GitHub packages before integrating | 2026-06-13 | **Keep** — active (it's loaded in this very session) |
| vercel-deploy | Vercel monorepo deploy + debugging guide | 2026-07-01 | **Keep** — used by dashboard deploys |

Also in shared-base: `archive/perplexity/` — 22 old Perplexity prompt files from May.
Already archived and tiny; leave as-is unless you want them gone.

## cape-toolbox (24 entries)

| Skill | Purpose | Last activity | Recommendation |
|---|---|---|---|
| cape-brand | Visual identity pointer, auto-loaded by CLAUDE.md | 2026-05-18 | **Keep** — infrastructure |
| cape-voice | Voice/tone pointer, auto-loaded | 2026-05-18 | **Keep** — infrastructure |
| source-registry | Source policy, auto-loaded | 2026-05-18 | **Keep** — infrastructure |
| cape-research-operating-playbook | Research Operating Playbook **v2.0**, "canonical Cape research methodology" | 2026-05-18 | **Keep** — canonical |
| cape-research-playbook | The same playbook, older version, no version number | 2026-05-18 | **Delete** — superseded by v2.0 above; two canonical playbooks is how drift starts |
| cape-moonshot-playbook | Moonshot Playbook v1.1: scoring, revisiting, Tuesday pack | 2026-06-11 | **Keep** — canonical moonshot method |
| cape-moonshot-research-playbook | Moonshot research orchestration, inherits from the playbook | 2026-06-11 | **Keep** — pairs with the above |
| cape-moonshots | Older moonshot framework doc: taxonomy, S/J-curve, scoring | 2026-05-18 | **Merge** — fold anything not already in playbook v1.1 into it, then delete; three moonshot docs is two too many |
| cape-html | Cape-branded HTML presentations | 2026-05-20 | **Keep** |
| cape-pptx | Native PowerPoint in Cape brand | 2026-05-18 | **Keep** |
| cape-pptx-to-html | Convert .pptx to Cape HTML deck | 2026-05-18 | **Keep** (low cost; used with client decks) |
| cape-presentation-summary | Investment presentation → 250-word Cape summary | 2026-05-18 | Your call — keep if the Proteins-style summaries still happen |
| cape-podcast-summary | Podcast → investor-grade summary | 2026-05-18 | Your call — same test: used since May? |
| cape-social | Cape research → LinkedIn/internal posts | 2026-05-18 | Your call — keep only if you actually post |
| dashboard-builder | Synthesis doc → interactive HTML dashboard | 2026-05-18 | **Keep** |
| deep-research | Pointer stub to research-orchestrator agent | 2026-05-18 | **Keep** — thin router, costs nothing |
| simple-research | Single-Claude focused research flow | 2026-05-18 | **Keep** |
| runbook-creator | Interview-style scaffolder for new runbooks | 2026-05-18 | **Keep** |
| cape-coding-best-practice | Scaffolds coding projects for Claude Code | 2026-05-28 | **Keep** — matches your dev workflow |
| iran-specific | 3 sub-tools (bonbast FX, Hormuz tracker, data updater) | 2026-05-18 | **Keep** — Iran runbooks are live (weekly update) |
| thematic-deepdive | Step files + templates, **no SKILL.md** | 2026-05-07 | **Archive** — oldest item in the repo, superseded by research-orchestrator; keep templates only if referenced |
| thematic-investment-idea | Self-labelled "RECLASSIFIED — this is a runbook, not a skill" | 2026-05-18 | **Move** to `runbooks/` as it says, delete the skill stub |
| weekly-pack | Also self-labelled "RECLASSIFIED — runbook"; but no `runbooks/weekly-pack/` exists yet | 2026-05-18 | **Move** content to `runbooks/weekly-pack/`, delete the stub — right now the reclassification is half-done |

## brh-toolbox (11 skills)

| Skill | Purpose | Last activity | Recommendation |
|---|---|---|---|
| brh-persona-brand | Firm identity/voice/typography, load for any BRH task | 2026-06-05 | **Keep** — infrastructure |
| brh-newsletter | Router for Les 4 Saisons sections | 2026-05-18 | **Keep** — entry point |
| brh-newsletter-editorial | Editorial section, 400-600 words | 2026-05-18 | **Keep** |
| brh-newsletter-revue-marche | Market review section | 2026-05-18 | **Keep** |
| brh-newsletter-investissements | Investment theme section | 2026-05-18 | **Keep** |
| brh-newsletter-wealth-patrimoine | Patrimoine section | 2026-05-18 | **Keep** |
| brh-newsletter-3-chiffres | Three figures section | 2026-05-18 | **Keep** |
| brh-newsletter-translate | FR→EN idea-preserving translation | 2026-05-18 | **Keep** |
| brh-market-data | Input protocol for your performance tables | 2026-05-18 | **Keep** — feeds revue-marche |
| brh-stock-memo | 6-Minute Single Stock Analysis memo | 2026-05-18 | Your call — used since May? |
| brh-output-menu | **Empty description** | 2026-05-18 | **Delete** — a skill that can't say what it does won't ever trigger; recreate properly if the idea was good |

## Net effect if you take every recommendation

Delete/merge/move 6 items in cape-toolbox, delete 1 in brh-toolbox, fold 1 subfolder
in shared-base. Result: ~32 skills, each with one canonical home, no duplicate
playbooks, no half-reclassified stubs. Disk impact is trivial (these are text);
the win is that you and Claude stop loading contradictory doctrine.

Separate from skills: `brh-finance-february` carries ~11,000 files of
`node_modules` + `dist`, all regenerable with one `npm install`. If that project
is dormant, delete those two folders and reclaim the space; git ignores them anyway.
