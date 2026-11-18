import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportofolio_mobile/main.dart';

void main() {
  testWidgets('shows owner identity in InfoCards', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('2506637073'), findsOneWidget);
    expect(find.text('Muhamad Idris Kamal'), findsOneWidget);
    expect(find.text('KKI'), findsOneWidget);
  });

  testWidgets('shows every portfolio action button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    for (final name in [
      'View Projects',
      'Add Project',
      'View Skills',
      'View Education',
      'Contact Me',
      'Logout',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('tapping a button shows a SnackBar with its name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('View Projects'));
    await tester.pump();

    expect(find.text('You pressed the View Projects button!'), findsOneWidget);
  });

  testWidgets('a new tap replaces the current SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Add Project'));
    await tester.pump();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('You pressed the Logout button!'), findsOneWidget);
    expect(find.text('You pressed the Add Project button!'), findsNothing);
  });
}
