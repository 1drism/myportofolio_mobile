import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';

/// Pages reachable from [LeftDrawer].
enum DrawerDestination {
  home('Home', Icons.home_outlined),
  addProject('Add Project', Icons.add_circle_outline),
  addEducation('Add Education', Icons.history_edu_outlined);

  const DrawerDestination(this.label, this.icon);

  final String label;
  final IconData icon;

  /// Page to open; null for Home, which pops back to the root instead.
  Widget? get page => switch (this) {
    home => null,
    addProject => const ProjectFormPage(),
    addEducation => const EducationFormPage(),
  };
}

/// Navigation drawer shared by every page; [current] is highlighted.
class LeftDrawer extends StatelessWidget {
  final DrawerDestination current;

  const LeftDrawer({super.key, required this.current});

  /// Home pops back to the root page; forms are pushed from Home and
  /// replace each other elsewhere, so Back always leads to Home.
  void _open(BuildContext context, DrawerDestination destination) {
    final navigator = Navigator.of(context);
    if (destination == current) {
      navigator.pop();
      return;
    }
    final page = destination.page;
    if (page == null) {
      navigator.popUntil((route) => route.isFirst);
      return;
    }
    final route = MaterialPageRoute<void>(builder: (_) => page);
    if (current == DrawerDestination.home) {
      navigator
        ..pop()
        ..push(route);
    } else {
      navigator.pushReplacement(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: const BoxDecoration(
              color: AppColors.paper,
              border: Border(bottom: BorderSide(color: AppColors.accent)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          for (final destination in DrawerDestination.values)
            ListTile(
              leading: Icon(destination.icon),
              title: Text(destination.label),
              selected: destination == current,
              onTap: () => _open(context, destination),
            ),
        ],
      ),
    );
  }
}
