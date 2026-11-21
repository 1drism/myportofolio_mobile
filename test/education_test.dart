import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/models/education.dart';

void main() {
  group('validateRequiredText', () {
    test('rejects empty and whitespace-only values', () {
      for (final value in [null, '', '   ', '\t\n']) {
        expect(
          Education.validateRequiredText(value, 'Institution'),
          'Institution is required.',
        );
      }
    });

    test('accepts exactly 100 characters and rejects 101', () {
      expect(Education.validateRequiredText('a' * 100, 'Degree'), isNull);
      expect(
        Education.validateRequiredText('a' * 101, 'Degree'),
        'Degree must be at most 100 characters.',
      );
    });

    test('ignores surrounding spaces when checking length', () {
      expect(Education.validateRequiredText('  ${'a' * 100}  ', 'X'), isNull);
    });
  });

  group('date rules', () {
    final start = DateTime(2025, 8, 18);

    test('start date is required', () {
      expect(Education.validateStartDate(null), 'Start date is required.');
      expect(Education.validateStartDate(start), isNull);
    });

    test('end date is optional and may equal the start date', () {
      expect(Education.validateEndDate(null, start), isNull);
      expect(Education.validateEndDate(start, start), isNull);
    });

    test('end date cannot be before the start date', () {
      expect(
        Education.validateEndDate(DateTime(2025, 8, 17), start),
        'End date cannot be before start date.',
      );
    });
  });

  group('period', () {
    test('shows Present while ongoing', () {
      final education = Education(
        institution: 'Universitas Indonesia',
        facultyOrMajor: 'Computer Science',
        degree: 'Bachelor',
        startedAt: DateTime(2025, 8, 18),
      );
      expect(education.isOngoing, isTrue);
      expect(education.period, 'Aug 2025 – Present');
    });

    test('shows the end month when finished', () {
      final education = Education(
        institution: 'SMA',
        facultyOrMajor: 'Science',
        degree: 'High School',
        startedAt: DateTime(2022, 7, 1),
        endedAt: DateTime(2025, 5, 31),
      );
      expect(education.isOngoing, isFalse);
      expect(education.period, 'Jul 2022 – May 2025');
      expect(Education.formatDate(DateTime(2025, 5, 31)), '31 May 2025');
    });
  });
}
