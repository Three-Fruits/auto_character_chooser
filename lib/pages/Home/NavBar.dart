import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  String pageName = "/home";
  NavBar({Key? key, required this.pageName}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Header',
              style: textTheme.headline6,
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('Home'),
            selected: widget.pageName == '/home',
            onTap: () => selectDestination('/home'),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ExpansionTile(
            title: Text('Valorant'),
            // subtitle: Text('Leading expansion arrow icon'),
            initiallyExpanded: widget.pageName.contains('valorant'),
            controlAffinity: ListTileControlAffinity.leading,
            children: [
              ListTile(
                leading: Icon(Icons.people_outline),
                title: Text('Agents'),
                selected: widget.pageName == '/valorant_agents',
                onTap: () => selectDestination('/valorant_agents'),
              ),
              ListTile(
                leading: ImageIcon(
                  AssetImage("images/Classic_prime_VALORANT.png"),
                ),
                title: Text('Weapons'),
                selected: widget.pageName == "/valorant_weapons",
                onTap: () => {/*selectDestination("/valorant_weapons")*/},
              ),
              ListTile(
                leading: Icon(Icons.label),
                title: Text('Skins (soon)'),
                onTap: () => null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void selectDestination(String name) {
    setState(() {
      widget.pageName = name;
    });
    Navigator.pushReplacementNamed(context, name);
  }
}
