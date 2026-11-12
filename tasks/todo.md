# Task List: Flutter Bench Public Leaderboard Prototype

## Module 1: Benchmark Data & Calculation Engine (`bench-data`)
- [ ] Task 1.1: Create structured benchmark dataset with launch roster
  - Acceptance: `sites/www/content/flutterbench/results.json` created with valid JSON containing Antigravity (Gemini 2.5 Pro, Gemini 2.5 Flash), Claude Code (Claude 3.7 Sonnet, Claude 3.5 Haiku), and Codex (GPT-4.5, GPT-4o) across both Baseline and AI Tooling variants, each with 4 trials per task across Short/Long horizon categories.
  - Verify: Valid JSON syntax check and task trial presence.
  - Files: `sites/www/content/flutterbench/results.json`

- [ ] Task 1.2: Implement benchmark models and calculator engine
  - Acceptance: `bench_models.dart` and `bench_calculator.dart` created with typed models and functions for Pass Rate (`outcome == 1.0`), Pass@4 (`trials.any(t => t.outcome == 1.0)`), Result Score (`0.60 * outcome + 0.30 * quality + 0.10 * dx`), standard deviation, tokens, cost, and delta calculation.
  - Verify: Functions compute expected values on test cases.
  - Files: `sites/www/lib/src/models/flutterbench/bench_models.dart`, `sites/www/lib/src/utils/bench_calculator.dart`

- [ ] Task 1.3: Add unit tests for calculation engine
  - Acceptance: Unit tests in `test/flutterbench/calculator_test.dart` cover Pass Rate, Pass@4, Result Score weights, standard deviation, and deltas.
  - Verify: `dart test test/flutterbench/calculator_test.dart` passes.
  - Files: `sites/www/test/flutterbench/calculator_test.dart`

## Module 2: Leaderboard UI & Controls (`leaderboard-ui`)
- [ ] Task 2.1: Add SCSS styles for Flutter Bench
  - Acceptance: `sites/www/lib/styles/pages/_flutterbench.scss` created and forwarded in `sites/www/lib/styles/styles.scss`, incorporating flutter.dev design tokens, table alignment, variant badges, deltas, pill cards, and drawer animation.
  - Verify: SCSS compiles without syntax errors.
  - Files: `sites/www/lib/styles/pages/_flutterbench.scss`, `sites/www/lib/styles/styles.scss`

- [ ] Task 2.2: Implement Leaderboard Controls and Methodology Card
  - Acceptance: `bench_controls.dart` created with agent/model filter (top-left) with 1-click clear, and 3-state variant toggle (top-right: Baseline, AI Tooling, Both). `bench_methodology_card.dart` created with ~100-150 words of prose linking to `/flutterbench/methodology`.
  - Verify: Controls render with correct event callbacks.
  - Files: `sites/www/lib/src/components/flutterbench/bench_controls.dart`, `sites/www/lib/src/components/flutterbench/bench_methodology_card.dart`

- [ ] Task 2.3: Implement Leaderboard Table and Page Container
  - Acceptance: `bench_table.dart` created with sortable headers, right-aligned formatted numbers, distinct badges for Baseline/AI tooling, delta indicators, and row click handler. `flutterbench_page.dart` created to orchestrate filtering, sorting, variant toggling, and data loading.
  - Verify: `/flutterbench` renders correctly with sorting, filtering, and variant toggling.
  - Files: `sites/www/lib/src/components/flutterbench/bench_table.dart`, `sites/www/lib/src/pages/flutterbench_page.dart`, `sites/www/content/flutterbench/index.md`, `sites/www/lib/main.server.dart`

## Module 3: Row Detail Slide-Over Drawer (`row-detail-view`)
- [ ] Task 3.1: Implement Slide-Over Detail Drawer Component
  - Acceptance: `bench_detail_drawer.dart` created with header, summary cards (Pass Rate, Pass@4, Avg Score, Tokens, Cost), Outcome/Quality/DX breakdown pill cards (colored label top-left, large value bottom-right), and per-task breakdown table (Task Name, Category, Avg Score with Outcome/Quality/DX). Respects active variant toggle and closes on backdrop click or close button.
  - Verify: Clicking a row opens drawer with matching details and closes properly.
  - Files: `sites/www/lib/src/components/flutterbench/bench_detail_drawer.dart`, `sites/www/lib/src/pages/flutterbench_page.dart`

## Module 4: Methodology Page (`methodology-page`)
- [ ] Task 4.1: Author long-form technical methodology page
  - Acceptance: `sites/www/content/flutterbench/methodology.md` created with the 4 required sections: Overview & Goals, Dataset Design, Grading & Scoring Design, and Limitations & Caveats.
  - Verify: Page accessible at `/flutterbench/methodology` with native article layout.
  - Files: `sites/www/content/flutterbench/methodology.md`

## Module 5: Verification & Documentation Deliverables
- [ ] Task 5.1: Create documentation notes and verify build & tests
  - Acceptance: `sites/www/content/flutterbench/README.md` created detailing data schema, update procedures, and component gap decisions. Unit tests pass and static analysis passes.
  - Verify: `dart test test/flutterbench/calculator_test.dart` passes.
  - Files: `sites/www/content/flutterbench/README.md`
