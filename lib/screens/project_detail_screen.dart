import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';

/// Shows every attribute of one [Project].
class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({required this.project, super.key});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.projectImageUrl.isNotEmpty) ...[
              Container(
                height: 184,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Image.network(
                  project.projectImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(formatTechStack(project.techStack), style: techStackStyle),
            const SizedBox(height: 8),
            Text(
              project.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              project.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider, height: 32),
            const Text('PROJECT URL', style: techStackStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.projectUrl,
                    style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_outward,
                  size: 16,
                  color: AppColors.accent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
