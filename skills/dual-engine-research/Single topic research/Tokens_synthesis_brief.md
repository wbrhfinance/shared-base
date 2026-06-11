# Tokens at CAPE: how we are using LLMs and what it costs us

Synthesis brief for the CAPE presentation. As of 26 May 2026. Built from a Perplexity breadth sweep, a ChatGPT Deep Research structural pass, a supplementary Perplexity dive on consumption levers, and an 11-rule video summary from Patel-style user-level Claude guidance.

Sources are tagged Perplexity (P), ChatGPT (C), Levers PDF (L), or Video (V). Claims are tagged (a) confirmed fact, (b) widely-cited consensus, (c) emerging signal.

---

## 1. Bottom line

We are riding an exponential adoption curve with Claude and the wider LLM stack. AI token usage roughly doubled in the opening weeks of 2026, driven mostly by agentic workflows that burn five to ten times more tokens per task than a chat. Headline list prices fell tenfold per year from 2022 to 2025, but in April 2026 the frontier tier inflected upward for the first time. Net effect at CAPE: our spend is going up faster than our usage feels, because per-task token counts are ballooning while frontier prices have stopped falling. The cost discipline this presentation lays out is not optional; it is the price of staying on the adoption curve without losing control of the bill.

---

## 2. The curve we are on, and the puzzle inside it

The exponential growth is real. OpenRouter recorded 100 trillion tokens processed in 2025. Reports point to token usage roughly doubling in the opening weeks of 2026, with agentic systems (multi-step reasoning, tool use, agent subroutines) as the main driver. (b, P+L)

The puzzle: list prices were falling tenfold per year and yet enterprise bills keep rising. Three reasons. First, the frontier tier reversed in April 2026: GPT-5.5 launched at $5/$30 per million tokens, double GPT-5.4, and Gemini 3.1 Pro carries a 60% input premium over Gemini 2.5 Pro. (a, P) Second, agentic workflows consume five to ten times more tokens per user intent than chat. (b, L) Third, conversation history is silently expensive: research cited in the video reports that around 98.5% of tokens consumed in a long chat go to re-reading prior turns, and only 1.5% to generating the new answer. (b, V)

For CAPE: the variable to manage is consumption, not list price. Negotiating rate cards is the wrong slide. Disciplining usage is the right slide.

---

## 3. What a token actually is

A token is a model-specific subword fragment produced by byte-pair encoding. Not a word, not a character. One token is roughly four English characters, or 0.75 of an English word, so 100 tokens is about 75 words. Non-English scripts cost two to three times more tokens for the same meaning. (a, P+C)

The same English sentence costs different numbers of tokens across vendors. Anthropic shipped a new tokenizer with Opus 4.7 that encodes up to 35% more tokens than its predecessor for the same text, an effective price hike with no list-price change. (a, P+C)

The context window is the working memory budget for a single call. It includes the system prompt, the conversation history, tool definitions, uploaded files, the user query, and any hidden reasoning tokens. Every token in that window is billable, including the invisible ones. (a, C)

---

## 4. The two asymmetries that drive cost

Almost every cost-saving rule below is a consequence of two structural facts.

**Asymmetry 1: output is four to six times more expensive than input.** Output tokens are generated one at a time and tie up GPU memory for the duration. Input can be processed in parallel. Reasoning models add an invisible third category: thinking tokens that the user does not see but pays for as output. Anthropic, OpenAI, and Google all confirm this. (a, P+C)

**Asymmetry 2: every new turn in a chat re-reads the entire prior conversation.** The model has no persistent memory of your earlier turns. To respond to turn 11, it bills you for re-reading turns 1 through 10 plus the new turn. The 98.5% statistic from the video is the operating consequence. (b, V)

These two facts mean the highest-leverage controls are: do not let output run long, and do not let history bloat.

---

## 5. The CAPE operating playbook: 12 rules

Eleven from the video, plus one structural rule the video misses. Grouped by what they manage.

### Group A: manage the conversation

**Rule 1. Edit, do not follow up.** If Claude's answer is wrong, click the edit pencil on your original prompt and regenerate. A follow-up correction adds to history and gets re-read on every subsequent turn. Editing replaces the exchange. (V)

**Rule 2. Restart every 15 to 20 messages.** A 100-message conversation can burn over 2.5 million tokens before generating its next response. Ask Claude to summarise the conversation, copy the summary, open a new chat, paste it as turn one. You keep the context, you drop the bloat. (V)

**Rule 3. Batch your questions.** Send "summarise this, list the main points, and suggest a headline" as one prompt, not three. One context load instead of three. Often produces better answers because the model sees the full task at once. (V)

### Group B: use Claude's built-in tooling

**Rule 4. Track your token usage.** Install Paweł Huryn's local dashboard which reads Claude's JSONL logs on your machine to show input, output, cache usage, and cost estimates retroactively. You cannot manage what you cannot see. (V)

**Rule 5. Upload recurring files to a Project, not to each chat.** Project content is cached on Anthropic's side; uploading the same PDF to ten chats re-tokenises it ten times. (V)

**Rule 6. Set memory and user preferences once.** Settings → Memory. Saves three to five setup messages per chat ("I'm a marketer, casual tone, etc."). Effectively a compressed system prompt that follows you across sessions. (V)

### Group C: choose the right model and features

**Rule 7. Turn off features you are not using.** Web search, connectors, Explore Mode, Advanced Thinking all add tokens to every response, used or not. Default to off, switch on when needed. (V)

**Rule 8. Use Haiku for simple tasks, Sonnet for real work, Opus only for deep reasoning.** Grammar checks, brainstorming, formatting, quick translations work on Haiku at a fraction of the cost. The list-price spread between Haiku ($1/$5 per million tokens) and Opus 4.7 ($5/$25) is fivefold; the spread to commodity models like Gemini 2.5 Flash-Lite is fiftyfold. (V, prices in P)

**Rule 9 (the missing one). Be concise.** Add "Be concise" to any prompt. Research cited in the broader sweep shows this single instruction reduces output length by 40% to 90%. Since output is four to six times more expensive than input, this is the highest-leverage single word in the playbook. (b, L)

### Group D: time and pay smart

**Rule 10. Spread work across the day.** Claude's usage limit runs on a rolling five-hour window that does not reset at midnight. Messages sent at 9am no longer count against you by 2pm. Working in three sessions (morning, afternoon, evening) lets old usage expire while new work fits inside fresh limits. (V)

**Rule 11. Work off-peak.** Since 26 March 2026, Anthropic depletes your five-hour session limit faster during peak hours: 5am to 11am Pacific, equivalent to 8am to 2pm Eastern, weekdays only. Heavy resource work in the evening or on weekends stretches your plan. (V)

**Rule 12. Enable overage billing.** Pro and Max subscribers can enable pay-as-you-go in Settings → Usage. Instead of blocking when you hit the limit, Claude switches to API rates. Set a monthly cap to avoid surprises. (V)

### What each rule actually does, in one line

| Rule | Why it works |
|---|---|
| 1 Edit don't follow up | Stops history from being re-read every turn |
| 2 Restart every 15-20 messages | Resets the 98.5% history-rereading tax |
| 3 Batch questions | One context load instead of N |
| 4 Track usage | Visibility, no behavioural change without data |
| 5 Use Projects for recurring files | Vendor-side cache, not re-tokenised each chat |
| 6 Memory and preferences | Compressed persistent system prompt |
| 7 Turn off unused features | Each feature adds tokens to every call |
| 8 Right model for right task | The list-price spread is 50x between tiers |
| 9 "Be concise" | Output is 4-6x more expensive than input |
| 10 Spread the day | The five-hour window is rolling, not midnight |
| 11 Off-peak | Anthropic meters peak hours faster as of 26 March 2026 |
| 12 Overage billing | Avoids the hard cut-off, controls maximum spend |

---

## 6. The wider market context, in three slides

For CAPE colleagues who want the surrounding picture beyond Claude.

**The market is bifurcating, not deflating.** Commodity tier keeps falling (DeepSeek V4-Flash cache hits at $0.0029 per million tokens, roughly one-seventh of GPT-5.5). Frontier tier inflected upward in April 2026 for the first time. The barbell is tightening, not closing. (a, P)

**Enterprise pricing has stopped converging.** Anthropic Enterprise: seat covers access, all usage billed at API rates. OpenAI Business: seat-based with "unlimited core chat" but Codex is pure pay-as-you-go. Azure: PTUs and reservations. AWS Bedrock: Standard, Flex, Priority, Reserved tiers. The product category "enterprise AI pricing" no longer has a default shape. (a, C)

**Token consumption growth outpaces unit-price compression.** Even if a model price falls 50%, if your usage doubles, your bill stays flat. If usage triples on agentic workflows, your bill goes up. The headline number to watch internally is total spend per month, not negotiated unit price. (b, P+L)

---

## 7. What changes in the next 12 months

Three concrete watchpoints.

**Reasoning becomes a separate priced product.** OpenAI already bills reasoning effort as output. Anthropic sells a 6x fast-mode premium on Opus. Within twelve months expect three distinct invoice lines: plain generation, throughput reasoning, agent-runtime execution. (c, C)

**The orchestration layer matures.** Bedrock markets intelligent prompt routing within model families. OpenRouter routes across 60+ providers. The commercial destination is an execution graph with multiple metered hops, each independently optimisable, not "one model one price." (c, C+P)

**EU AI Act fully applies from 2 August 2026.** Google's Gemini API already requires paid services for EEA, Swiss, and UK clients. OpenAI publishes regional-processing uplifts. Anthropic publishes US-only inference at a premium. Sovereign and regional inference will increasingly appear as a pricing line, not just a compliance one. Matters for CAPE because we are Zurich-based. (b, C)

---

## 8. Open questions and watchpoints

Five things the public record does not resolve, worth flagging on the deck if you want to be honest:

- **Are 70% inference margins at Anthropic and OpenAI sustainable?** Sources are industry blogs, not primary disclosures, and they sit next to $8B+ operating losses at OpenAI. The signal is contradictory.
- **What does the typical enterprise actually spend per seat?** No provider discloses it. Public estimates range from $60 to $250 per seat per month.
- **What cache hit rate do production deployments actually achieve?** Academic studies show 41-80%; no vendor publishes real-world numbers.
- **Where is the inference cost floor?** DeepSeek at $0.003 per million tokens suggests sub-$0.001 may be physically achievable.
- **Is the frontier price reversal structural or cyclical?** MindStudio argues 70% margins imply imminent price cuts. Moov AI argues the upgrade treadmill is slowing and costs are rising. Next two flagship launches will resolve this.

---

## 9. Implication for CAPE

Three takeaways for the firm.

**One. Tokens are a discipline, not a one-time fix.** The 12 rules above are operating hygiene, not a project. They need to become habits across the team.

**Two. The cost story is about consumption, not vendor selection.** Switching from Claude to Gemini saves nothing if our usage patterns are wasteful on both. The leverage is in how we use the tools, not which tool.

**Three. The biggest single intervention is also the cheapest.** Edit instead of follow up. Restart conversations. Add "Be concise." These cost nothing, require no engineering, and compound. Production teams report 47% to 80% reductions stacking only the simple levers.

The exponential growth curve is genuine and we should ride it. The discipline above is what stops it from quietly compounding into a bill we did not expect.

---

## 10. Sources

Primary documents and pricing pages: OpenAI, Anthropic, Google, Mistral, xAI, DeepSeek, Perplexity, Azure OpenAI, AWS Bedrock, Together, Fireworks, Groq pricing pages, all as of May 2026. FlashAttention paper (arxiv 2205.14135) and vLLM paper (arxiv 2309.06180) for the prefill / decode / KV-cache mechanism. EU AI Act regulatory framework page.

Analyst and trade press: Epoch AI on LLM inference price trends, a16z on LLMflation, OECD report on AI infrastructure competition (Nov 2025), GitHub blog on Copilot usage-based billing, McKinsey on cost of compute.

Practitioner research and production benchmarks: Mavik Labs LLM cost optimisation 2026, Oplexa AI inference cost crisis 2026, Iternal token usage guide, Mem0 and LangChain on context management, Redis on prompt caching, LLMLingua and AutoCompressors papers, MindStudio and Moov AI on Anthropic margins, Arxiv papers on caching production savings (2601.06007) and agentic token waste (2605.09104).

Video source: YouTube tip stack, https://youtu.be/2f7ZkImNHFo (11 user-level rules folded into Section 5).

Full reference lists are in the Perplexity PDF, the ChatGPT docx, and the Levers PDF in this folder.

---

## Editorial notes

- The framing is built around your line: "we are going through the exponential growth curve created by Claude, we also need to understand the cost of what we are doing and use the tools in a cost optimized way." The bottom line is the literal translation of that into a one-paragraph case.
- Rule 9 ("Be concise") is mine, not the video's. It comes from the broader research and is the highest-leverage single-word change available. Worth highlighting because the rest of the playbook is structural and this one is just a phrase to add.
- The 98.5% history-rereading statistic from the video is the most striking single number in the deck. I would put it on its own slide.
- I did not chase the YouTube link directly. The 11 tips are sourced from your typed summary. If any tip got transcribed incorrectly let me know and I will fix it.
- This brief is analytical and educational. Not investment-committee work, no CAPE house view embedded.

Next step, if you want it: I'll build a Cape-branded HTML deck from this brief. Target shape: title slide, the curve, the puzzle, what a token is, the two asymmetries, the 98.5% statistic, the 12-rule playbook (two slides), the market context, the 12-month forward view, open questions, the bottom line. Roughly 12 slides. Say the word.
