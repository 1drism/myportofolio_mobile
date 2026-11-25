import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

/// Pages reachable from [LeftDrawer].
enum DrawerDestination {
  home('Home', Icons.home_outlined),
  viewProjects('View Projects', Icons.folder_outlined),
  addProject('Add Project', Icons.add_circle_outline),
  addEducation('Add Education', Icons.history_edu_outlined);

  const DrawerDestination(this.label, this.icon);

  final String label;
  final IconData icon;

  /// Page to open; null for Home, which pops back to the root instead.
  Widget? get page => switch (this) {
    home => null,
    viewProjects => const ProjectListScreen(),
    addProject => const ProjectFormPage(),
    addEducation => const EducationFormPage(),
  };
}

/// Navigation drawer shared by every page; [current] is highlighted.
class LeftDrawer extends StatelessWidget {
  final DrawerDestination current;

  const LeftDrawer({super.key, required this.current});

  /// Home pops back to the root page; other pages are pushed from Home and
  /// replace each other elsewhere, so Back always leads to Home.
  /// Add Project asks for login first; login opens on top of the drawer.
  Future<void> _open(
    BuildContext context,
    DrawerDestination destination,
  ) async {
    if (destination == DrawerDestination.addProject && destination != current) {
      if (!await ensureLoggedIn(context)) return;
      if (!context.mounted) return;
    }
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

  void _openLogin(BuildContext context) {
    Navigator.of(context)
      ..pop()
      ..push(MaterialPageRoute<bool>(builder: (_) => const LoginScreen()));
  }

  void _logout(BuildContext context) {
    final auth = context.read<AuthState>();
    Navigator.pop(context);
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthState>().isLoggedIn;
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
          const Divider(color: AppColors.divider),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => _openLogin(context),
            ),
        ],
      ),
    );
  }
}
