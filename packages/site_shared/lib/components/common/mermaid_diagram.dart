// Copyright 2026 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Renders a Mermaid diagram element.
final class MermaidDiagram extends StatelessComponent {
  const MermaidDiagram({required this.diagram, super.key});

  /// The Mermaid diagram definition to render.
  final String diagram;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'mermaid-container',
      [
        pre(
          classes: 'mermaid',
          attributes: {'data-source': diagram},
          [.text(diagram)],
        ),
      ],
    );
  }
}
