import 'dart:ui';

import 'package:flutter/material.dart';

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final box = BoxDecoration(
      color: Colors.white.withValues(alpha: reduced ? .96 : .72),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: Colors.white.withValues(alpha: .7)),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: reduced
          ? DecoratedBox(decoration: box, child: child)
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: DecoratedBox(decoration: box, child: child),
            ),
    );
  }
}
