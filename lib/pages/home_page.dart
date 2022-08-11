import 'package:auto_character_chooser/pages/NavBar.dart';
import 'package:auto_character_chooser/pages/gamespage/BottomBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavBar(pageName: '/home'),
      bottomNavigationBar: BottomBarComponent(),
    );
  }
}
