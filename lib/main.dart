import 'package:auto_character_chooser/pages/gamespage/Valorant/AgentPage/valorant_agent_page.dart';
import 'package:auto_character_chooser/pages/home_page.dart';
import 'package:auto_character_chooser/themes/default_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Choose agent',
      theme: DefaultTheme().defaultTheme(),
      initialRoute: '/home',
      // ignore: prefer_const_literals_to_create_immutables
      routes: {
        '/home': (context) => const HomePage(),
        '/valorant_agents': (context) => const ValorantAgentPage(),
      },
    );
  }
}
