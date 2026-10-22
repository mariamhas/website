# Flutter Bench: Maintenance & Architecture Guide

This directory contains the data and documentation backing the **Flutter Bench** public leaderboard on `flutter.dev`.

## 1. Data Schema Overview

Benchmark evaluations are stored in `sites/www/content/flutterbench/results.json`. The dataset contains an array of model evaluation runs.

### Schema:
```json
[
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
          {
            "trialIndex": 1,
            "outcome": 1.0,  // 0.0 to 1.0 (1.0 = passed)
            "quality": 0.95, // 0.0 to 1.0
            "dx": 0.92       // 0.0 to 1.0
          }
        ]
      }
    ]
  }
]
```

## 2. How to Add a New Agent or Model

To add a new model evaluation:
1. Open `content/flutterbench/results.json`.
2. Add two run objects for the new model (one for `"variant": "baseline"` and one for `"variant": "ai_tooling"`).
3. Ensure each task in the run contains 4 trials ($K = 4$) with `outcome`, `quality`, and `dx` scores, as well as `tokens` and `cost`.
4. Run the automated test suite to verify math and schema integrity:
   ```bash
   dart test test/flutterbench/calculator_test.dart
   ```
5. The leaderboard table (`/flutterbench`), variant toggle deltas, and row detail drawers automatically recalculate all rollup statistics (Pass Rate, Pass@4, Avg Score, SD, Tokens, Cost) at build and runtime without requiring manual aggregate edits.

## 3. Flutter.dev Component Gaps & Decisions

During the implementation of Flutter Bench according to the PRD specifications, the following component patterns were addressed:

| Component Requirement | Existing flutter.dev Pattern | Gap / Workaround Decision |
|---|---|---|
| **Row Detail View (Side Pane / Drawer)** | `flutter.dev` primarily uses multi-column marketing grids and article layouts, with mobile hamburger menus acting as full-height overlays. There was no existing side-pane component for tabular row inspection. | **Decision**: Implemented an accessible, responsive slide-over drawer component (`bench_detail_drawer.dart` and `_flutterbench.scss`). On desktop viewports ($\ge 768\text{px}$), clicking any leaderboard row slides a $720\text{px}$ side drawer in from the right with a backdrop blur and smooth cubic-bezier transition. On mobile viewports, it smoothly transitions to a full-width overlay with a sticky header and touch-friendly close button. |
| **Result Score Breakdown Cards** | Existing card components (`FeatureColumn`, `StoryCard`) are designed for marketing imagery and text paragraphs. | **Decision**: Created the Android Bench metric card pattern directly within the drawer, featuring a top-left colored pill badge (`Outcome (60%)`, `Quality (30%)`, `Developer Experience (10%)`) and an oversized bottom-right numeric value ($26\text{px}$ bold tabular figures). |
| **Tabular Metric Comparison ("Both" Mode)** | Standard tables on `flutter.dev` display single scalar values per cell. | **Decision**: Engineered a composite cell layout in `bench_table.dart` when the "Both" variant is selected. Each cell stacks the AI Tooling value (with a blue badge), the Baseline value (with a neutral gray badge), and an automated delta pill indicator ($+X\%$ in teal/green or $-X\%$ in rose). |
