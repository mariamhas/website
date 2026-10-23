# Spec: Flutter Bench Public Leaderboard Prototype

## Objective
Build **Flutter Bench**, a public benchmark leaderboard and methodology section within the `flutter.dev` website (`sites/www`) inside the user repository (`mariamhas/website` at `https://github.com/mariamhas/website`), evaluating how effectively AI coding agents and models build Flutter and Dart applications.

The initial launch comprises:
1. **Leaderboard Page (`/flutterbench`)**: Interactive results table with quick agent/model filters, 3-state variant comparison (Baseline, With AI tooling, Both), sortable metrics, metric tooltips/legend, a methodology summary card, and a row-click slide-over drawer / detail view.
2. **Methodology Page (`/flutterbench/methodology`)**: A technical-article-style long-form document detailing benchmark goals, dataset design (CUJs), grading rubrics, rollup scoring formulas, and caveats.

## Assumptions & Architecture Fit
1. **Repository & Location**: Built directly inside `mariamhas/website` repository within `sites/www`, which is the canonical source tree for `flutter.dev` (alongside `sites/docs` for `docs.flutter.dev`).
2. **Structure Conformance**: Conforms 100% to the existing Jaspr and Jaspr Content site architecture:
   - Markdown content and routes placed in `sites/www/content/`.
   - Dart components placed in `sites/www/lib/src/components/` and pages in `sites/www/lib/src/pages/`.
   - Server registration in `sites/www/lib/main.server.dart`.
   - SCSS styling placed in `sites/www/lib/styles/pages/` and imported into `sites/www/lib/styles/styles.scss`.
3. **Design Language**: Reuses existing `sites/www` typography, colors, layout patterns, and SCSS/CSS utility classes without adding a separate design system.
4. **Data Source**: Data is driven by a structured JSON file `content/flutterbench/results.json` containing per-task trials for the launch roster.
5. **Detail View Pattern**: An accessible slide-over drawer / side panel component will be implemented using native dialog/HTML5 and CSS transitions, falling back cleanly on narrow screens.
6. **No Private Links**: In accordance with PRD non-goals, no external links to private evals repositories or dataset downloads will be displayed.

## Tech Stack & Dependencies
- **Language**: Dart (SDK ^3.6.0)
- **Web Framework**: Jaspr (`package:jaspr`, `package:jaspr_content`)
- **Serialization / Modeling**: `package:dart_mappable`
- **Routing**: Static content page resolution via Jaspr Content (`/flutterbench` and `/flutterbench/methodology`)

## Commands
```bash
# Install dependencies
dart pub get

# Run build_runner to generate serialization and Jaspr options
dart run build_runner build --delete-conflicting-outputs

# Serve dev site locally
dart run dash_site --site=www serve

# Build production static output
dart run dash_site --site=www build

# Analyze and format code
dart analyze sites/www
dart format sites/www
```

## Project Structure
```text
sites/www/
├── content/
│   └── flutterbench/
│       ├── index.md                 # Route handler & metadata for /flutterbench
│       ├── methodology.md           # Long-form article for /flutterbench/methodology
│       └── results.json             # Benchmark raw data (launch roster + trials)
├── lib/
│   ├── main.server.dart             # Registers FlutterBenchPage component
│   └── src/
│       ├── models/
│       │   └── flutterbench/        # Dart models for task runs, trials, aggregates
│       │       └── bench_models.dart
│       ├── pages/
│       │   └── flutterbench_page.dart # Leaderboard page component
│       ├── components/
│       │   └── flutterbench/        # Modular leaderboard components
│       │       ├── bench_table.dart
│       │       ├── bench_controls.dart
│       │       ├── bench_detail_drawer.dart
│       │       ├── bench_methodology_card.dart
│       │       └── metric_card.dart
│       └── utils/
│           └── bench_calculator.dart # Pass Rate, Pass@4, Result Score, SD math
```

## Data Schema & Calculations
Each agent/model entry in `results.json` evaluates 7 representative Critical User Journeys (CUJs) across 4 trials ($K=4$):

### Representative Critical User Journeys (CUJs):
1. **Fix RenderFlex Overflow** (`cuj-01-renderflex-overflow`, Short-horizon): Resolving unbounded layout constraints, row/column overflow errors, and proper flex spacing.
2. **Navigation with Adaptive Layout** (`cuj-02-adaptive-layout-navigation`, Long-horizon): Multi-pane declarative routing (e.g. NavigationRail vs NavigationBar) with responsive breakpoint adaptations.
3. **REST API Client: Fetch JSON with http** (`cuj-03-rest-api-http`, Short-horizon): HTTP service with error handling, deserialization, and async state mapping.
4. **Provider State Management** (`cuj-04-provider-state-mgmt`, Short-horizon): Centralizing state with `ChangeNotifier`, `ChangeNotifierProvider`, and `Consumer` widgets.
5. **Firebase Cloud Storage** (`cuj-05-firebase-cloud-storage`, Long-horizon): Integrating file uploads, downloads, progress listeners, and error recovery with Firebase Storage.
6. **Dart Genkit Cloud Function** (`cuj-06-dart-genkit-function`, Long-horizon): Authoring serverless Dart AI flows using Firebase Functions and the Genkit Dart SDK.
7. **Internationalization (i18n)** (`cuj-07-internationalization-i18n`, Short-horizon): Multi-language localization with `.arb` translation files and `AppLocalizations`.

Example schema in `results.json`:
```json
{
  "agent": "Antigravity",
  "model": "Gemini 2.5 Pro",
  "variant": "ai_tooling", // "baseline" or "ai_tooling"
  "tasks": [
    {
      "id": "cuj-01-renderflex-overflow",
      "name": "Fix RenderFlex Overflow",
      "category": "short_horizon", // "short_horizon" or "long_horizon"
      "tokens": 28400,
      "cost": 0.052,
      "trials": [
        {"trialIndex": 1, "outcome": 1.0, "quality": 0.95, "dx": 0.92},
        {"trialIndex": 2, "outcome": 1.0, "quality": 0.94, "dx": 0.90},
        {"trialIndex": 3, "outcome": 1.0, "quality": 0.96, "dx": 0.95},
        {"trialIndex": 4, "outcome": 1.0, "quality": 0.95, "dx": 0.92}
      ]
    }
  ]
}
```

### Formulas & Scoring Purpose
- **Trial Passed (`outcome == 1.0`)**: 
  - *Purpose*: Defines the atomic success threshold for a single trial execution. In automated benchmarks, each CUJ is run $K=4$ independent times. If all automated unit/widget/integration test assertions pass with zero runtime errors, `outcome` equals `1.0`. A score below `1.0` denotes partial failure or failing test assertions.
  - *Used by*:
    - **Pass Rate**: Mean percentage of all attempted trials that achieved complete success (`outcome == 1.0`).
    - **Pass@4 Rate**: Percentage of CUJ tasks where an agent succeeded in *at least one* out of the 4 attempts (`trials.any((t) => t.outcome == 1.0)`).
- **Task Result Score**: `(outcome * 0.60) + (quality * 0.30) + (dx * 0.10)` on a 0.0–1.0 scale.
- **Overall Avg Score (%)**: Mean Result Score across all tasks * 100, presented with standard deviation: `${mean.toStringAsFixed(1)}% ± ${sd.toStringAsFixed(1)}%`.
- **Avg Tokens & Cost**: Arithmetic mean per task run.

## Code Style
- Follow Effective Dart and Jaspr immutability conventions.
- Use `const` constructors wherever possible.
- Separate stateful UI interactions (filter selection, variant switching, drawer open/close) into clear `@client` or `StatefulComponent` classes.

Example:
```dart
class MetricPill extends StatelessComponent {
  const MetricPill({required this.label, required this.value, required this.color, super.key});
  final String label;
  final String value;
  final String color;

  @override
  Component build(BuildContext context) {
    return div(classes: 'bench-metric-pill $color', [
      span(classes: 'label', [.text(label)]),
      span(classes: 'value', [.text(value)]),
    ]);
  }
}
```

## Testing Strategy
- **Unit Tests** (`sites/www/test/flutterbench/calculator_test.dart`):
  - Verify Pass Rate calculation (`outcome == 1.0`).
  - Verify Pass@4 calculation logic (1 of 4 passed).
  - Verify weighted average Result Score (60% Outcome / 30% Quality / 10% DX).
  - Verify standard deviation computation.
  - Verify delta calculations in "Both" variant mode.
- **Static Analysis**: `dart analyze sites/www` must pass with zero issues.

## Boundaries
- **Always do**:
  - Follow flutter.dev layout, fonts, header, and footer.
  - Compute aggregates from raw task/trial data rather than hardcoding them.
  - Right-align numbers with fixed decimals and currency formatting.
  - Ensure mobile usability with horizontal table scrolling and responsive drawer sizing.
- **Ask first**:
  - Adding any new third-party pub dependencies.
  - Modifying the global top navigation bar in `header.dart`.
- **Never do**:
  - Link to internal or unreleased benchmark repositories or prompt files.
  - Add "Submit your model" contact forms.
  - Hardcode top-level leaderboard numbers without raw task trial backing.

## Success Criteria
1. Navigating to `/flutterbench` renders the Flutter Bench header, quick filter, 3-state variant toggle, sortable table, metric legend, and methodology teaser card.
2. The variant toggle toggles between Baseline, With AI Tooling, and Both (with clear visual badges and delta indicators).
3. Clicking any leaderboard row smoothly opens a side pane/drawer showing top-level metric cards, the Outcome (60%) / Quality (30%) / DX (10%) breakdown cards, and a per-task table.
4. Navigating to `/flutterbench/methodology` displays the full technical methodology article matching the site's layout.
5. All calculations for Pass Rate, Pass@4, Avg Score, Tokens, Cost, and SD are dynamically derived from the sample dataset.
6. `dart analyze sites/www` and tests pass cleanly.

## Open Questions & Decisions
1. **Detail View Pattern**: Confirmed slide-over side drawer / panel component with full-screen responsive overlay on mobile, matching flutter.dev styling, layout tokens, and transitions.
2. **Initial Roster Models**:
   - Antigravity: `Gemini 2.5 Pro`, `Gemini 2.5 Flash`
   - Claude Code: `Claude 3.7 Sonnet`, `Claude 3.5 Haiku`
   - Codex: `GPT-4.5`, `GPT-4o` (removed o3-mini as requested)
