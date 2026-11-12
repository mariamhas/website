# Implementation Plan: Flutter Bench Public Leaderboard Prototype

## Summary
Implement a high-level, working prototype of **Flutter Bench** on `flutter.dev` (`sites/www`) based on the approved specification and PRD. Flutter Bench consists of two primary pages: the interactive **Leaderboard Page** (`/flutterbench`) and the technical **Methodology Page** (`/flutterbench/methodology`), powered by a structured JSON dataset and dynamic calculation engine.

## Architecture & Dependency Graph
```
results.json (raw task trials)
     │
     ▼
bench_models.dart & bench_calculator.dart (models & statistics engine)
     │
     ├───► unit tests (calculator_test.dart)
     │
     ▼
bench_table.dart + bench_controls.dart + bench_methodology_card.dart
     │
     ├───► flutterbench_page.dart (/flutterbench)
     │           │
     │           ▼
     │     bench_detail_drawer.dart (slide-over row inspection)
     │
     ▼
methodology.md (/flutterbench/methodology)
```

## Vertical Slices & Modules

### Phase 1: Data Model, Calculation Engine & Tests (`bench-data`)
- **JSON Dataset (`content/flutterbench/results.json`)**: Realistic task evaluations across 4 trials for Antigravity (Gemini 2.5 Pro, Gemini 2.5 Flash), Claude Code (Claude 3.7 Sonnet, Claude 3.5 Haiku), and Codex (GPT-4.5, GPT-4o) in both Baseline and AI Tooling variants.
- **Dart Models (`lib/src/models/flutterbench/bench_models.dart`)**: Data structures for Trial, TaskRun, ModelBenchmarkRun, and AggregateMetrics.
- **Calculator (`lib/src/utils/bench_calculator.dart`)**: Strict implementation of Pass Rate (`outcome == 1.0`), Pass@4 (`at least 1 of 4 passed`), Result Score (60% Outcome + 30% Quality + 10% DX), standard deviation, tokens, cost, and deltas.
- **Unit Tests (`test/flutterbench/calculator_test.dart`)**: Verify mathematical precision, edge cases, and delta comparisons.

### Phase 2: Leaderboard UI & Table Controls (`leaderboard-ui`)
- **Styles (`lib/styles/pages/_flutterbench.scss` & forwarded in `styles.scss`)**: Table styling, sort arrows, variant badges, deltas, pill cards, and responsive wrappers using flutter.dev CSS variables.
- **Controls (`bench_controls.dart`)**: Agent/model filter (top-left) with single-click clear; 3-state variant toggle (top-right: Baseline, AI Tooling, Both).
- **Table (`bench_table.dart`)**: Sortable columns (default Pass Rate desc), right-aligned numbers with thousands separators and `$`, room to breathe, row click handlers.
- **Methodology Card (`bench_methodology_card.dart`)**: ~100-150 words of prose under table with link to `/flutterbench/methodology`.
- **Page Container (`flutterbench_page.dart`)**: Coordinates data decoding, filter/sort state, and renders `/flutterbench`.

### Phase 3: Row Detail Slide-Over Drawer (`row-detail-view`)
- **Drawer Component (`bench_detail_drawer.dart`)**:
  - Slide-over panel from right with animated entrance and backdrop dismissal.
  - Header with agent, model, and active variant.
  - Top summary cards: Pass Rate, Pass@4, Avg Score, Tokens, Cost.
  - Outcome / Quality / DX breakdown cards (colored pill label top-left, large value bottom-right).
  - Per-task table listing task names, categories (Short/Long horizon), and Outcome/Quality/DX breakdown. Respects variant toggle.

### Phase 4: Methodology Page (`methodology-page`)
- **Markdown Document (`content/flutterbench/methodology.md`)**:
  - Technical-blog-style article registered under DefaultLayout.
  - 4 required sections: Overview & Goals, Dataset Design, Grading & Scoring, Limitations & Caveats.

### Phase 5: Verification & Documentation
- Deliverable note on schema update workflow and component gap decisions.
- Execute unit tests (`dart test test/flutterbench/calculator_test.dart`).
- Validate static analysis (`dart analyze sites/www`).
