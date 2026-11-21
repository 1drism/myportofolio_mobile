import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/education.dart';
import 'package:myportofolio_mobile/widgets/date_form_field.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

const double _pagePadding = 16.0;
const double _fieldSpacing = 16.0;
const double _maxFormWidth = 600.0;

/// Form for adding an education entry, matching the Django `Education` model.
class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final DateTime _firstDate = DateTime(1950);
  final DateTime _lastDate = DateTime(DateTime.now().year + 10, 12, 31);

  String _institution = '';
  String _facultyOrMajor = '';
  String _degree = '';
  DateTime? _startedAt;
  DateTime? _endedAt;
  String _description = '';

  /// Validates every field, then shows the saved entry in a dialog.
  Future<void> _save() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    final education = Education(
      institution: _institution,
      facultyOrMajor: _facultyOrMajor,
      degree: _degree,
      startedAt: _startedAt!,
      endedAt: _endedAt,
      description: _description,
    );
    await showDialog<void>(
      context: context,
      builder: (context) => _EducationSummaryDialog(education),
    );
  }

  Widget _textField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, hintText: hint),
      maxLength: Education.maxTextLength,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      validator: (value) => Education.validateRequiredText(value, label),
      onSaved: (value) => onSaved(value!.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Education')),
      drawer: const LeftDrawer(current: DrawerDestination.addEducation),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(_pagePadding),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxFormWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: _fieldSpacing,
                  children: [
                    _textField(
                      label: 'Institution',
                      hint: 'Universitas Indonesia',
                      onSaved: (value) => _institution = value!,
                    ),
                    _textField(
                      label: 'Faculty / Major',
                      hint: 'Computer Science',
                      onSaved: (value) => _facultyOrMajor = value!,
                    ),
                    _textField(
                      label: 'Degree',
                      hint: 'Bachelor',
                      onSaved: (value) => _degree = value!,
                    ),
                    DateFormField(
                      label: 'Start Date',
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      onChanged: (value) => _startedAt = value,
                      validator: Education.validateStartDate,
                      onSaved: (value) => _startedAt = value,
                    ),
                    DateFormField(
                      label: 'End Date',
                      helperText: 'Leave empty while it\'s ongoing.',
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      clearable: true,
                      validator: (value) =>
                          Education.validateEndDate(value, _startedAt),
                      onSaved: (value) => _endedAt = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        hintText: 'Activities, GPA, or achievements',
                        alignLabelWithHint: true,
                      ),
                      minLines: 3,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onSaved: (value) => _description = value!.trim(),
                    ),
                    ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog listing every value of a saved [Education].
class _EducationSummaryDialog extends StatelessWidget {
  final Education education;

  const _EducationSummaryDialog(this.education);

  @override
  Widget build(BuildContext context) {
    final end = education.endedAt;
    final rows = {
      'Institution': education.institution,
      'Faculty / Major': education.facultyOrMajor,
      'Degree': education.degree,
      'Start Date': Education.formatDate(education.startedAt),
      'End Date': end == null ? 'Ongoing' : Education.formatDate(end),
      'Period': education.period,
      'Description': education.description.isEmpty
          ? '-'
          : education.description,
    };

    return AlertDialog(
      title: const Text('Education saved!'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12,
          children: [
            for (final MapEntry(:key, :value) in rows.entries)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    key.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(value),
                ],
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
