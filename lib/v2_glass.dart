import 'dart:ui';

import 'package:flutter/material.dart';

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(24);
    final base = dark ? const Color(0xFF25262D) : Colors.white;
    final accent = Color.lerp(base, theme.colorScheme.primary, dark ? .16 : .11)!;
    final topAlpha = highContrast ? (dark ? .96 : .98) : (dark ? .60 : .46);
    final middleAlpha = highContrast ? (dark ? .94 : .96) : (dark ? .50 : .34);
    final bottomAlpha = highContrast ? (dark ? .92 : .94) : (dark ? .42 : .26);

    final body = Stack(
      fit: StackFit.passthrough,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0, .48, 1],
              colors: [
                base.withValues(alpha: topAlpha),
                accent.withValues(alpha: middleAlpha),
                base.withValues(alpha: bottomAlpha),
              ],
            ),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: highContrast ? .34 : .28)
                  : Colors.white.withValues(alpha: highContrast ? .96 : .80),
              width: 1,
            ),
          ),
          child: child,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.center,
                  stops: const [0, .24, .62],
                  colors: [
                    Colors.white.withValues(alpha: dark ? .16 : .38),
                    Colors.white.withValues(alpha: dark ? .05 : .12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final clipped = ClipRRect(
      borderRadius: radius,
      child: highContrast
          ? body
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: body,
            ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .28 : .13),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: dark ? .04 : .20),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: clipped,
    );
  }
}
