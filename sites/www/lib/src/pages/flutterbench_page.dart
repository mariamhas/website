// Copyright 2026, the Flutter authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/flutterbench/bench_subnav.dart';
import '../models/flutterbench/bench_models.dart';
import '../utils/data_utils.dart';
import 'flutterbench_interactive.dart';

/// Server-side page component for `/flutterbench`.
///
/// Renders the shared heading and sub-navigation, then loads benchmark
/// results and passes the raw JSON list to the client-hydrated
/// [FlutterBenchInteractive] component.
class FlutterBenchPage extends StatelessComponent {
  const FlutterBenchPage({super.key});

  @override
  Component build(BuildContext context) {
    List<Map<String, Object?>> rawData = const [];
    try {
      final runs = context.decodeJsonList(
        'flutterbench.results',
        BenchModelRun.fromJson,
      );
      rawData = runs.map(_modelRunToJson).toList();
    } catch (_) {
      // Fallback empty when data is not available
    }

    return main_(classes: 'flutterbench-page', [
      div(classes: 'container', [
        // Page Title & Subtitle
        const div(classes: 'bench-header', [
          h1(classes: 'bench-title', [.text('Flutter Bench')]),
          p(classes: 'bench-subtitle', [
            .text(
              'A public leaderboard measuring how effectively AI coding '
              'agents and models build Flutter and Dart applications.',
            ),
          ]),
        ]),

        // Sub-navigation tabs: Leaderboard · Methodology · Archive
        const BenchSubnav(activePage: 'leaderboard'),
      ]),

      // Client-hydrated interactive leaderboard
      FlutterBenchInteractive(rawRunsJson: rawData),
    ]);
  }

  /// Converts a [BenchModelRun] back to a JSON map for client serialization.
  static Map<String, Object?> _modelRunToJson(BenchModelRun run) => {
    'agent': run.agent,
    'model': run.model,
    'variant': run.variant.value,
    'tasks': run.tasks.map((t) => {
      'id': t.id,
      'name': t.name,
      'category': t.category.value,
      'tokens': t.tokens,
      'cost': t.cost,
      'trials': t.trials.map((tr) => tr.toJson()).toList(),
    }).toList(),
  };
}
