// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';

import 'package:auto_character_chooser/pages/NavBar.dart';
import 'package:auto_character_chooser/pages/gamespage/BottomBar.dart';
import 'package:auto_character_chooser/pages/gamespage/Valorant/AgentPage/valorant_agent_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class ValorantAgentPage extends StatefulWidget {
  const ValorantAgentPage({Key? key}) : super(key: key);

  @override
  State<ValorantAgentPage> createState() => _ValorantAgentPageState();
}

class _ValorantAgentPageState extends State<ValorantAgentPage> {
  StreamController<int> controller = StreamController<int>();
  List<ValorantAgent> agents = List.empty(growable: true);
  bool isFirstTime = true;
  bool isLoading = true;

  void loadAgents() async {
    isLoading = true;
    agents = await ValorantAgentNetwork().getAgents();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print("Loading agents starting...");
    loadAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: NavBar(pageName: '/valorant_agents'),
      body: !isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isFirstTime
                    ? Center(
                        child: TextButton(
                        child: Text("Press here to shuffle"),
                        onPressed: () => spinWheel(),
                      ))
                    : FortuneBar(
                        height: 400,
                        visibleItemCount: 1,
                        fullWidth: true,
                        onFling: () {
                          spinWheel();
                        },
                        animateFirst: false,
                        selected: controller.stream,
                        items: [
                          for (var agent in agents)
                            FortuneItem(
                              child: Container(
                                height: double.infinity,
                                child: Text(agent.displayName),
                                color: Colors.red,
                              ),
                              style: FortuneItemStyle(borderWidth: 10),
                            ),
                        ],
                      ),
              ],
            )
          : Center(
              child: Text("Loading..."),
            ),
      bottomNavigationBar: BottomBarComponent(),
      floatingActionButton: !isLoading
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                spinWheel();
              })
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void spinWheel({int id = -1}) {
    isFirstTime = false;
    if (id == -1) {
      var rng = Random();
      id = rng.nextInt(agents.length);
    }
    controller.add(id);
    setState(() {});
  }
}
