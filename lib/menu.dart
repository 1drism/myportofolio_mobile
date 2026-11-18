import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/app_colors.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

const double _pagePadding = 16.0;
const double _sectionSpacing = 16.0;
const double _gridSpacing = 10.0;
const double _maxContentWidth = 600.0;
const int _gridColumns = 3;
const double _cardRadius = 12.0;
const double _itemIconSize = 30.0;

/// Home screen showing the owner's identity and the portfolio action menu.
class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506637073";
  final String nama = "Muhamad Idris Kamal";
  final String kelas = "KKI";

  final List<ItemHomepage> items = [
    ItemHomepage("View Projects", Icons.folder, AppColors.blue),
    ItemHomepage("Add Project", Icons.add_circle, AppColors.accent),
    ItemHomepage("View Skills", Icons.code, AppColors.purple),
    ItemHomepage("View Education", Icons.school, AppColors.green),
    ItemHomepage("Contact Me", Icons.mail, AppColors.orange),
    ItemHomepage("Logout", Icons.logout, AppColors.danger),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyPortfolio')),
      drawer: const LeftDrawer(),
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

/// Data for one action button: its label, icon, and background color.
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

/// Colored action button that shows a SnackBar with its name when tapped.
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_cardRadius);
    final foreground =
        ThemeData.estimateBrightnessForColor(item.color) == Brightness.dark
        ? AppColors.ink
        : AppColors.paperDark;

    return Material(
      color: item.color,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You pressed the ${item.name} button!")),
            );
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, color: foreground, size: _itemIconSize),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
