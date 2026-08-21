import 'dart:ui';

import 'package:flutter/material.dart';

class AppGlassSurface extends StatelessWidget {
  const AppGlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.blurSigma = 22,
  });

  final Widget child;
  final double radius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(radius);
    final base = dark ? const Color(0xFF25262D) : Colors.white;
    final accent =
        Color.lerp(base, theme.colorScheme.primary, dark ? .16 : .11)!;
    final topAlpha = highContrast ? (dark ? .96 : .98) : (dark ? .60 : .46);
    final middleAlpha = highContrast ? (dark ? .94 : .96) : (dark ? .50 : .34);
    final bottomAlpha = highContrast ? (dark ? .92 : .94) : (dark ? .42 : .26);

    final body = Stack(
      fit: StackFit.passthrough,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
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
                borderRadius: borderRadius,
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
      borderRadius: borderRadius,
      child: highContrast
          ? body
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
              child: body,
            ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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

class AppGlassInset extends StatelessWidget {
  const AppGlassInset({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.radius = 16,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final highContrast = MediaQuery.maybeOf(context)?.highContrast ?? false;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(radius);
    final base = dark ? const Color(0xFF202129) : Colors.white;
    final accent = accentColor ?? Theme.of(context).colorScheme.primary;

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base.withValues(alpha: highContrast ? .94 : (dark ? .54 : .54)),
            Color.lerp(base, accent, dark ? .18 : .10)!
                .withValues(alpha: highContrast ? .92 : (dark ? .44 : .38)),
            base.withValues(alpha: highContrast ? .90 : (dark ? .34 : .26)),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: highContrast ? (dark ? .42 : .96) : (dark ? .18 : .72),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? .16 : .055),
            blurRadius: 14,
            spreadRadius: -6,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );

    if (highContrast) return content;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      ),
    );
  }
}
