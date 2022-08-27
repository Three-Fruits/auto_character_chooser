import 'package:auto_character_chooser/pages/Home/home_page.dart';
import 'package:auto_character_chooser/pages/Home/setting_page.dart';
import 'package:auto_character_chooser/pages/gamespage/Valorant/AgentPage/valorant_agent_page.dart';
import 'package:auto_character_chooser/pages/gamespage/tf2/classpage/tf2_agent_page.dart';
import 'package:auto_character_chooser/services/local_data.dart';
import 'package:auto_character_chooser/themes/default_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MyLocalData().initLocalData();
  }

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
        '/tf2_agents': (context) => const Tf2AgentPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
