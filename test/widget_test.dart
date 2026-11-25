import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('shows owner identity in InfoCards', (WidgetTester tester) async {
    await tester.pumpWidget(testApp());

    expect(find.text('2506637073'), findsOneWidget);
    expect(find.text('Muhamad Idris Kamal'), findsOneWidget);
    expect(find.text('KKI'), findsOneWidget);
  });

  testWidgets('shows every portfolio action button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp());

    for (final name in [
      'View Projects',
      'Add Project',
      'View Skills',
      'View Education',
      'Add Education',
      'Contact Me',
      'Logout',
    ]) {
      expect(find.text(name), findsOneWidget);
    }
  });

  testWidgets('tapping a button without a page shows a SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp());

    await tester.tap(find.text('View Skills'));
    await tester.pump();

    expect(find.text('You pressed the View Skills button!'), findsOneWidget);
  });

  testWidgets('a new tap replaces the current SnackBar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp());

    await tester.tap(find.text('View Skills'));
    await tester.pump();
    await tester.ensureVisible(find.text('Logout'));
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('You pressed the Logout button!'), findsOneWidget);
    expect(find.text('You pressed the View Skills button!'), findsNothing);
  });

  testWidgets('View Projects lists API projects and opens the detail', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(testApp());

    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectListScreen), findsOneWidget);
    expect(find.text('DJANGO · PYTHON · GIT'), findsOneWidget);

    await tester.tap(find.text('Personal Portfolio Website'));
    await tester.pumpAndSettle();

    expect(find.byType(ProjectDetailScreen), findsOneWidget);
    expect(find.text('PROJECT URL'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('list shows the empty state', (WidgetTester tester) async {
    await tester.pumpWidget(testApp((_) async => http.Response('[]', 200)));

    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(find.text('No projects found.'), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
  });

  testWidgets('list shows the error state and Retry reloads', (
    WidgetTester tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      testApp((_) async {
        calls++;
        return calls == 1
            ? http.Response('Internal Server Error', 500)
            : http.Response(jsonEncode([sampleProjectJson]), 200);
      }),
    );

    await tester.tap(find.text('View Projects'));
    await tester.pumpAndSettle();

    expect(find.text('Failed to load projects'), findsOneWidget);
    expect(
      find.text('ApiException(500): Internal Server Error'),
      findsOneWidget,
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Personal Portfolio Website'), findsOneWidget);
    expect(calls, 2);
  });
}
