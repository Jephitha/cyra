import 'package:cyra/features/insights/screens/ai_disclaimer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('describes insights as deterministic and on-device', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AIDisclaimerScreen()));

    expect(find.text('Smart Local Insights'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Medical Disclaimer'),
      500,
      scrollable: find.byType(Scrollable),
    );
    expect(
      find.textContaining(
        'does not send your health data to a remote AI model',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('AI-powered'), findsNothing);
  });
}
