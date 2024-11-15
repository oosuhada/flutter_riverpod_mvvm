import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_mvvm/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loads repository user into the Riverpod state card',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('Riverpod MVVM Lab'), findsOneWidget);
    expect(find.text('대기 중'), findsOneWidget);

    final fetchButton = find.text('사용자 데이터 가져오기');
    await tester.ensureVisible(fetchButton);
    await tester.tap(fetchButton);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('이지원'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('데이터 다시 가져오기'), findsOneWidget);
  });
}
