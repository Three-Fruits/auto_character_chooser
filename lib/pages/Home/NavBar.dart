import 'package:auto_character_chooser/themes/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return SafeArea(
      child: Drawer(
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
              leading: SizedBox(
                child: ImageIcon(
                  AssetImage(MyImages.valorantLogo),
                ),
              ),
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
                    AssetImage(MyImages.valorantPistol),
                  ),
                  title: Text('Weapons (soon)'),
                  selected: widget.pageName == "/valorant_weapons",
                  onTap: () => {
                    /*selectDestination("/valorant_weapons")*/
                  },
                ),
                ListTile(
                  leading: Icon(Icons.label),
                  title: Text('Skins (soon)'),
                  onTap: () => null,
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
            ),
            ExpansionTile(
              title: const Text('Team Fortress 2'),
              leading: SizedBox(
                child: ImageIcon(
                  AssetImage(MyImages.tf2logo),
                ),
              ),
              // subtitle: Text('Leading expansion arrow icon'),
              initiallyExpanded: widget.pageName.contains('tf2'),
              controlAffinity: ListTileControlAffinity.leading,
              children: [
                ListTile(
                  leading: Icon(Icons.people_outline),
                  title: Text('Agents'),
                  selected: widget.pageName == '/tf2_agents',
                  onTap: () => selectDestination('/tf2_agents'),
                ),
                ListTile(
                  leading: ImageIcon(
                    AssetImage(MyImages.valorantPistol),
                  ),
                  title: Text('Weapons (soon)'),
                  selected: widget.pageName == "/tf2_weapons",
                  onTap: () => {
                    /*selectDestination("/valorant_weapons")*/
                  },
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
      ),
    );
  }

  void selectDestination(String name) {
    setState(() {
      widget.pageName = name;
    });
    if (name == '/home') {
      Navigator.pushReplacementNamed(context, name);
    } else {
      Navigator.pushNamed(context, name);
    }
  }
}
