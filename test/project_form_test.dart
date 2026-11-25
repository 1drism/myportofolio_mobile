import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

import 'test_helpers.dart';

Finder _field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  testWidgets('logged-out Add Project logs in, then a valid Save is posted', (
    tester,
  ) async {
    http.Request? posted;
    await tester.pumpWidget(
      testApp((request) {
        if (request.method == 'POST' &&
            request.url.path == '/api/v1/projects/') {
          posted = request;
        }
        return fakeBackend(request);
      }),
    );

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await tester.enterText(_field('Username'), 'user');
    await tester.enterText(_field('Password'), 'pass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectFormPage), findsOneWidget);

    await tester.enterText(_field('Title'), 'MyPortfolio Mobile');
    await tester.enterText(_field('Description'), 'Flutter client.');
    await tester.enterText(_field('Tech Stack'), 'Flutter, Dart');
    await tester.enterText(_field('Project URL'), 'https://github.com/x/y');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(posted!.headers['Authorization'], 'Token $testToken');
    final body = jsonDecode(posted!.body) as Map<String, dynamic>;
    expect(body['tech_stack'], 'Flutter, Dart');
    expect(body['project_image_url'], '');
    expect(find.text('Project added successfully!'), findsOneWidget);
    expect(find.text('Tech stack: Flutter, Dart'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('MyPortfolio Mobile'), findsNothing);
  });

  testWidgets('a 401 on Save logs out and asks for login again', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp((request) async {
        if (request.method == 'POST' &&
            request.url.path == '/api/v1/projects/') {
          return http.Response('{"detail": "Invalid token."}', 401);
        }
        return fakeBackend(request);
      }),
    );
    await logIn(tester);

    await tester.tap(find.text('Add Project'));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Title'), 'T');
    await tester.enterText(_field('Description'), 'D');
    await tester.enterText(_field('Tech Stack'), 'Dart');
    await tester.enterText(_field('Project URL'), 'https://x.dev');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(
      find.text('Your session has expired. Please log in again.'),
      findsOneWidget,
    );
  });
}
