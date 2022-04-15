import 'package:flutter/material.dart';
import 'package:coffee/widgets/stockScreenerList.dart';
import 'package:coffee/widgets/favoritesList.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.blueAccent,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 48),
            buildMenuItem(
                text: 'Markets',
                icon: Icons.trending_up,
                onClicked: () => selectedItem(context, 0)),
            const SizedBox(height: 14),
            buildMenuItem(
                text: 'Favorites',
                icon: Icons.star,
                onClicked: () => selectedItem(context, 1)),
            const SizedBox(height: 24),
            const Divider(
              color: Colors.white60,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    const hoverColor = Colors.white60;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const StockScreenerList(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const FavoritesList(),
        ));
    }
  }
}
