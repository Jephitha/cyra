import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cyra/app/app.dart';

void main() {
  testWidgets('Cyra app renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CyraApp()));
    await tester.pumpAndSettle();

    expect(find.text('Cyra'), findsOneWidget);
  });

  testWidgets('Cyra app has correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CyraApp()));
    await tester.pumpAndSettle();

    final titleFinder = find.text('Cyra');
    expect(titleFinder, findsOneWidget);
  });
}
