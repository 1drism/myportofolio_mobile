import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';

const _phone = Size(360, 640);
const _desktop = Size(1280, 800);

/// Pumps the app at [size] with an optional on-screen keyboard height.
Future<void> _pumpApp(
  WidgetTester tester, {
  Size size = _phone,
  double keyboard = 0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MyApp());
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Finder _drawerItem(String label) =>
    find.descendant(of: find.byType(Drawer), matching: find.text(label));

Future<void> _openFromDrawer(WidgetTester tester, String label) async {
  await tester.tap(find.byTooltip('Open navigation menu'));
  await tester.pumpAndSettle();
  await tester.tap(_drawerItem(label));
  await tester.pumpAndSettle();
}

Future<void> _openFromCard(WidgetTester tester) =>
    _tapVisible(tester, find.text('Add Education'));

Future<void> _save(WidgetTester tester) =>
    _tapVisible(tester, find.text('Save'));

/// Opens the date picker at [index] (0 = start, 1 = end) and picks [day].
Future<void> _pickDay(WidgetTester tester, int index, String day) async {
  await _tapVisible(
    tester,
    find.byIcon(Icons.calendar_today_outlined).at(index),
  );
  await tester.tap(find.text(day));
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Finder _textField(int index) => find.byType(TextFormField).at(index);

bool _canPop(WidgetTester tester) =>
    tester.state<NavigatorState>(find.byType(Navigator)).canPop();

void main() {
  group('navigation', () {
    testWidgets('action card pushes the form and system Back returns home', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);

      expect(find.byType(EducationFormPage), findsOneWidget);
      expect(find.text('Add Education'), findsOneWidget);

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.byType(MyHomePage), findsOneWidget);
      expect(_canPop(tester), isFalse);
    });

    testWidgets('drawer opens the form and highlights it', (tester) async {
      await _pumpApp(tester);
      await _openFromDrawer(tester, 'Add Education');
      expect(find.byType(EducationFormPage), findsOneWidget);

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();
      final tile = tester.widget<ListTile>(
        find.ancestor(
          of: _drawerItem('Add Education'),
          matching: find.byType(ListTile),
        ),
      );
      expect(tile.selected, isTrue);
    });

    testWidgets('Home in the drawer returns to the home screen', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);
      await _openFromDrawer(tester, 'Add Project');
      await _openFromDrawer(tester, 'Add Education');
      await _openFromDrawer(tester, 'Home');

      expect(find.byType(MyHomePage), findsOneWidget);
      expect(find.byType(EducationFormPage), findsNothing);
      expect(_canPop(tester), isFalse);
    });
  });

  group('validation', () {
    testWidgets('empty Save shows an error next to each required field', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);
      await _save(tester);

      expect(find.text('Institution is required.'), findsOneWidget);
      expect(find.text('Faculty / Major is required.'), findsOneWidget);
      expect(find.text('Degree is required.'), findsOneWidget);
      expect(find.text('Start date is required.'), findsOneWidget);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('rejects spaces only, over 100 characters, and end < start', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);

      await tester.enterText(_textField(0), '    ');
      await tester.enterText(_textField(1), 'x' * 101);
      await tester.enterText(_textField(2), 'Bachelor');
      await _pickDay(tester, 0, '15');
      await _pickDay(tester, 1, '10');
      await _save(tester);

      expect(find.text('Institution is required.'), findsOneWidget);
      expect(
        find.text('Faculty / Major must be at most 100 characters.'),
        findsOneWidget,
      );
      expect(find.text('Degree is required.'), findsNothing);
      expect(
        find.text('End date cannot be before start date.'),
        findsOneWidget,
      );
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('editing after a failed Save', () {
    testWidgets('errors clear as each field is fixed', (tester) async {
      await _pumpApp(tester);
      await _openFromCard(tester);
      await _save(tester);

      await tester.enterText(_textField(0), 'Universitas Indonesia');
      await tester.pump();
      expect(find.text('Institution is required.'), findsNothing);
      expect(find.text('Degree is required.'), findsOneWidget);

      await _pickDay(tester, 0, '15');
      expect(find.text('Start date is required.'), findsNothing);
    });

    testWidgets('no errors appear while typing before the first Save', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);

      await tester.enterText(_textField(0), '   ');
      await tester.pump();
      expect(find.text('Institution is required.'), findsNothing);
    });

    testWidgets('changing the start date re-checks the end date', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);
      await _pickDay(tester, 0, '15');
      await _pickDay(tester, 1, '10');
      await _save(tester);
      expect(
        find.text('End date cannot be before start date.'),
        findsOneWidget,
      );

      await _pickDay(tester, 0, '5');
      expect(find.text('End date cannot be before start date.'), findsNothing);
    });

    testWidgets('keyboard stays closed after picking a date', (tester) async {
      await _pumpApp(tester);
      await _openFromCard(tester);

      await tester.showKeyboard(_textField(0));
      expect(tester.testTextInput.isVisible, isTrue);

      await _pickDay(tester, 0, '15');
      expect(find.byType(DatePickerDialog), findsNothing);
      expect(tester.testTextInput.isVisible, isFalse);
    });
  });

  group('summary dialog', () {
    testWidgets('valid Save shows every value and OK resets the form', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _openFromCard(tester);

      await tester.enterText(_textField(0), '  Universitas Indonesia  ');
      await tester.enterText(_textField(1), 'Computer Science');
      await tester.enterText(_textField(2), 'Bachelor');
      await _pickDay(tester, 0, '15');
      await tester.enterText(_textField(3), 'Fasilkom UI student');
      await _save(tester);

      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      for (final value in [
        'Universitas Indonesia',
        'Computer Science',
        'Bachelor',
        'Ongoing',
        'Fasilkom UI student',
      ]) {
        expect(
          find.descendant(of: dialog, matching: find.text(value)),
          findsOneWidget,
        );
      }
      expect(
        find.descendant(of: dialog, matching: find.textContaining('Present')),
        findsOneWidget,
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(EducationFormPage), findsOneWidget);

      final texts = tester.widgetList<EditableText>(find.byType(EditableText));
      expect(
        texts.map((field) => field.controller.text),
        everyElement(isEmpty),
      );
      final dates = tester.stateList<FormFieldState<DateTime>>(
        find.byType(DateFormField),
      );
      expect(dates.map((field) => field.value), everyElement(isNull));
      expect(find.text('Institution is required.'), findsNothing);

      // The old start date must not be used to check a new end date.
      await _pickDay(tester, 1, '10');
      await _save(tester);
      expect(find.text('Start date is required.'), findsOneWidget);
      expect(find.text('End date cannot be before start date.'), findsNothing);
    });
  });

  group('layout', () {
    for (final (size, keyboard) in [
      (_phone, 0.0),
      (_phone, 300.0),
      (_desktop, 0.0),
    ]) {
      testWidgets('Save stays reachable at $size with keyboard $keyboard', (
        tester,
      ) async {
        await _pumpApp(tester, size: size, keyboard: keyboard);
        await _openFromCard(tester);
        await _save(tester);

        expect(find.text('Institution is required.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
