import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the architecture dashboard in idle state',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Riverpod MVVM Lab'), findsOneWidget);
    expect(find.text('View → ViewModel → Repository'), findsOneWidget);
    expect(find.text('No profile loaded yet'), findsOneWidget);
    expect(find.text('REQUESTS'), findsOneWidget);
    expect(find.text('state v0'), findsOneWidget);
  });

  testWidgets('shows loading then commits repository data to the View',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final fetchButton = find.byKey(const ValueKey('fetch-button'));
    await tester.ensureVisible(fetchButton);
    await tester.tap(fetchButton);
    await tester.pump();

    expect(find.text('Repository Future를 await 중 · View는 loading state를 구독 중'),
        findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('이지원'), findsOneWidget);
    expect(find.text('age 20'), findsOneWidget);
    expect(find.text('Flutter architecture learner'), findsOneWidget);
    expect(find.text('Riverpod · MVVM · immutable state'), findsOneWidget);
    expect(find.text('Mock REST · JSON'), findsOneWidget);
  });

  testWidgets('captures repository errors and can reset to idle',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    final errorButton = find.byKey(const ValueKey('error-button'));
    await tester.ensureVisible(errorButton);
    await tester.tap(errorButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('Repository request failed'), findsOneWidget);
    expect(find.text('503 · Sample API is unavailable'), findsOneWidget);

    final resetButton = find.byKey(const ValueKey('reset-button'));
    await tester.ensureVisible(resetButton);
    await tester.tap(resetButton);
    await tester.pump();

    expect(find.text('No profile loaded yet'), findsOneWidget);
    expect(find.text('REQUESTS'), findsOneWidget);
    expect(find.text('state v0'), findsOneWidget);
  });
}
