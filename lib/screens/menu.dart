import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

const double _pagePadding = 16.0;
const double _sectionSpacing = 16.0;
const double _gridSpacing = 10.0;
const double _maxContentWidth = 600.0;
const int _gridColumns = 3;

/// Home screen showing the owner's identity and the portfolio action menu.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506637073";
  final String nama = "Muhamad Idris Kamal";
  final String kelas = "KKI";

  final List<ItemHomepage> items = [
    ItemHomepage("View Projects", Icons.folder, AppColors.blue),
    ItemHomepage(
      "Add Project",
      Icons.add_circle,
      AppColors.accent,
      page: (_) => const ProjectFormPage(),
    ),
    ItemHomepage("View Skills", Icons.code, AppColors.purple),
    ItemHomepage("View Education", Icons.school, AppColors.green),
    ItemHomepage(
      "Add Education",
      Icons.history_edu,
      AppColors.cyan,
      page: (_) => const EducationFormPage(),
    ),
    ItemHomepage("Contact Me", Icons.mail, AppColors.orange),
    ItemHomepage("Logout", Icons.logout, AppColors.danger),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyPortfolio')),
      drawer: const LeftDrawer(current: DrawerDestination.home),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [AppColors.accentGlow, Colors.transparent],
            stops: [0.0, 0.35],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_pagePadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxContentWidth),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: InfoCard(title: 'NPM', content: npm),
                        ),
                        Expanded(
                          flex: 3,
                          child: InfoCard(title: 'Name', content: nama),
                        ),
                        Expanded(
                          flex: 2,
                          child: InfoCard(title: 'Class', content: kelas),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: _sectionSpacing * 2),

                  const Text(
                    'Welcome to MyPortfolio Mobile!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),

                  const SizedBox(height: _sectionSpacing),

                  GridView.count(
                    crossAxisCount: _gridColumns,
                    crossAxisSpacing: _gridSpacing,
                    mainAxisSpacing: _gridSpacing,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card showing one piece of owner information, e.g. NPM or name.
class InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data for one action button: its label, icon, color, and optional page.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  /// Page opened with [Navigator.push]; null shows a SnackBar instead.
  final WidgetBuilder? page;

  ItemHomepage(this.name, this.icon, this.color, {this.page});
}
