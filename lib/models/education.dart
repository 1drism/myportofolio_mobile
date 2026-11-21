/// Education entry mirroring the Django `Education` model.
class Education {
  /// Matches `CharField(max_length=100)` on the Django model.
  static const int maxTextLength = 100;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final String institution;
  final String facultyOrMajor;
  final String degree;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String description;

  const Education({
    required this.institution,
    required this.facultyOrMajor,
    required this.degree,
    required this.startedAt,
    this.endedAt,
    this.description = '',
  });

  bool get isOngoing => endedAt == null;

  /// Period label like the Django site, e.g. "Aug 2025 – Present".
  String get period {
    final end = endedAt;
    return '${formatMonth(startedAt)} – ${end == null ? 'Present' : formatMonth(end)}';
  }

  /// Formats a date as "Aug 2025".
  static String formatMonth(DateTime date) =>
      '${_months[date.month - 1]} ${date.year}';

  /// Formats a date as "17 Aug 2025".
  static String formatDate(DateTime date) => '${date.day} ${formatMonth(date)}';

  /// Required text up to [maxTextLength] characters; spaces alone are rejected.
  static String? validateRequiredText(String? value, String label) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label is required.';
    if (text.length > maxTextLength) {
      return '$label must be at most $maxTextLength characters.';
    }
    return null;
  }

  static String? validateStartDate(DateTime? value) =>
      value == null ? 'Start date is required.' : null;

  /// End date is optional (ongoing) but cannot come before [start].
  static String? validateEndDate(DateTime? end, DateTime? start) {
    if (end == null || start == null) return null;
    return end.isBefore(start) ? 'End date cannot be before start date.' : null;
  }
}
