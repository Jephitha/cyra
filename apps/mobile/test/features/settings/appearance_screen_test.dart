import 'package:cyra/core/design/app_theme.dart';
import 'package:cyra/features/settings/screens/appearance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Brightness brightness) => ProviderScope(
  child: MaterialApp(
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    home: const AppearanceScreen(),
  ),
);

void main() {
  testWidgets('does not expose a manual theme override', (tester) async {
    await tester.pumpWidget(_app(Brightness.light));
    await tester.pumpAndSettle();

    expect(find.text('Theme'), findsNothing);
    expect(find.text('Light'), findsNothing);
    expect(find.text('Dark'), findsNothing);
    expect(find.text('System'), findsNothing);
  });

  testWidgets('renders using the active system brightness', (tester) async {
    await tester.pumpWidget(_app(Brightness.dark));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, isNull);
  });
}
