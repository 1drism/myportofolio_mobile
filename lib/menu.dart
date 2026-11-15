import 'package:flutter/material.dart';

const double _pagePadding = 16.0;
const double _sectionSpacing = 16.0;
const double _gridSpacing = 10.0;
const double _maxContentWidth = 600.0;
const int _gridColumns = 3;
const double _cardRadius = 12.0;
const double _itemIconSize = 30.0;

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506637073";
  final String nama = "Muhamad Idris Kamal";
  final String kelas = "KKI";

  final List<ItemHomepage> items = [
    ItemHomepage("View Projects", Icons.folder, Colors.blue),
    ItemHomepage("Add Project", Icons.add_circle, Colors.green),
    ItemHomepage("View Skills", Icons.code, Colors.purple),
    ItemHomepage("View Education", Icons.school, Colors.teal),
    ItemHomepage("Contact Me", Icons.mail, Colors.deepOrange),
    ItemHomepage("Logout", Icons.logout, Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
    );
  }
}

class InfoCard extends StatelessWidget {
  // Information card displaying a title and its associated content.
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(_cardRadius);

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
              Icon(item.icon, color: Colors.white, size: _itemIconSize),
              const SizedBox(height: 6),
              Flexible(
                child: Text(
                  item.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
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
