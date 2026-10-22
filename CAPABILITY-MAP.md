# Capability Map: Flutter Bench

| Module ID | Responsibility | Depends On |
|---|---|---|
| `bench-data` | Benchmark schema, sample JSON dataset (launch roster: Antigravity/Gemini, Claude Code/Anthropic, Codex/OpenAI), Dart models (`dart_mappable`), and calculation engine (Pass Rate, Pass@4, Result Score 60/30/10, SD, tokens, cost). | — |
| `leaderboard-ui` | `/flutterbench` route, header, quick filter controls (agent/model), 3-state variant toggle (Baseline, With AI tooling, Both with deltas & badges), sortable metrics table, column tooltips / legend, methodology teaser card. | `bench-data` |
| `row-detail-view` | Per-row inspection component (slide-over drawer / modal), summary metric cards (Pass Rate, Pass@4, Avg Score, Tokens, Cost + Outcome/Quality/DX breakdown pills), per-task breakdown table respecting active variant. | `bench-data`, `leaderboard-ui` |
| `methodology-page` | `/flutterbench/methodology` long-form technical article layout following flutter.dev conventions (Overview & Goals, Dataset Design, Grading & Scoring Design, Limitations & Caveats). | — |

**Build Order:** `bench-data` → `leaderboard-ui` → `row-detail-view` → `methodology-page`
