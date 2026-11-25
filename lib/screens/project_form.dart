import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

const double _pagePadding = 16.0;
const double _fieldSpacing = 16.0;
const int _maxTextLength = 255;

String? _validateRequired(String? value, String label) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return '$label cannot be empty!';
  if (text.length > _maxTextLength) {
    return '$label must be at most $_maxTextLength characters.';
  }
  return null;
}

String? _validateUrl(String? value, {required bool required}) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return required ? 'Project URL cannot be empty!' : null;
  final uri = Uri.tryParse(text);
  final valid =
      uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
  return valid ? null : 'Enter a valid URL (http:// or https://).';
}

/// Form that creates a project through the authenticated REST API.
class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _techStack = '';
  String _projectUrl = '';
  String _projectImageUrl = '';
  bool _isSubmitting = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final project = Project(
      title: _title,
      description: _description,
      techStack: _techStack,
      projectUrl: _projectUrl,
      projectImageUrl: _projectImageUrl,
    );

    setState(() {
      _isSubmitting = true;
    });
    var sessionExpired = false;
    try {
      await context.read<ApiClient>().createProject(
        project,
        token: auth.token!,
      );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => _ProjectAddedDialog(project),
      );
      _formKey.currentState?.reset();
      _title = _description = _techStack = _projectUrl = _projectImageUrl = '';
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        sessionExpired = true;
      } else if (mounted) {
        _showSnackBar('Failed to add project (${e.statusCode}).');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }

    if (!sessionExpired) return;
    await auth.logout();
    if (!mounted) return;
    _showSnackBar('Your session has expired. Please log in again.');
    if (await ensureLoggedIn(context) && mounted) {
      await _submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project')),
      drawer: const LeftDrawer(current: DrawerDestination.addProject),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => _validateRequired(value, 'Title'),
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: _fieldSpacing),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  return text.isEmpty ? 'Description cannot be empty!' : null;
                },
                onSaved: (value) => _description = value!.trim(),
              ),
              const SizedBox(height: _fieldSpacing),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Tech Stack'),
                validator: (value) => _validateRequired(value, 'Tech Stack'),
                onSaved: (value) => _techStack = value!.trim(),
              ),
              const SizedBox(height: _fieldSpacing),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(labelText: 'Project URL'),
                validator: (value) => _validateUrl(value, required: true),
                onSaved: (value) => _projectUrl = value!.trim(),
              ),
              const SizedBox(height: _fieldSpacing),
              TextFormField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Project Image URL (optional)',
                ),
                validator: (value) => _validateUrl(value, required: false),
                onSaved: (value) => _projectImageUrl = value!.trim(),
              ),
              const SizedBox(height: _fieldSpacing),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectAddedDialog extends StatelessWidget {
  const _ProjectAddedDialog(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Project added successfully!'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text('Title: ${project.title}'),
            Text('Description: ${project.description}'),
            Text('Tech stack: ${project.techStack}'),
            Text('Project URL: ${project.projectUrl}'),
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
