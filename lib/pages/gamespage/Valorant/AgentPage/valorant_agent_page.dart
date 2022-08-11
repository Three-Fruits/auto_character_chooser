// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:auto_character_chooser/pages/gamespage/Home/NavBar.dart';
import 'package:auto_character_chooser/pages/gamespage/Valorant/AgentPage/valorant_agent_class.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shake/shake.dart';

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
  bool isSpinning = false;
  late ShakeDetector detector;

  void loadAgents() async {
    isLoading = true;
    agents = await ValorantAgentNetwork().getAgents();
    isLoading = false;

    detector = ShakeDetector.waitForStart(onPhoneShake: () {
      spinWheel();
    });
    detector.startListening();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detector.stopListening();
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/valorant_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: !isLoading
            ? Stack(
                alignment: Alignment.center,
                children: [
                  BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: !isFirstTime,
                      child: FortuneBar(
                        onAnimationEnd: () => onSpinEnd(),
                        onAnimationStart: () => onSpinStart,
                        styleStrategy: UniformStyleStrategy(
                          color: Colors.transparent,
                          borderColor: Colors.transparent,
                        ),
                        indicators: [],
                        height: double.infinity,
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
                              style: FortuneItemStyle(color: Colors.amber),
                              child: Container(
                                color: Colors.transparent,
                                height: double.infinity,
                                width: double.infinity,
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        child: ShaderMask(
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                              colors: agent
                                                  .backgroundGradientColors,
                                            ).createShader(bounds);
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: agent.background,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          blendMode: BlendMode.srcATop,
                                        ),
                                      ),
                                      Container(
                                        child: CachedNetworkImage(
                                          imageUrl: agent.fullPortrait,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isFirstTime)
                    InkWell(
                      onTap: () => spinWheel(),
                      child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        color: Colors.grey.withOpacity(0.5),
                        child: Text("Press here to shuffle"),
                      ),
                    )
                ],
              )
            : Center(
                child: Text("Loading..."),
              ),
      ),
      floatingActionButton: !isLoading && !isSpinning
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
    onSpinStart();
    setState(() {});
  }

  void onSpinEnd() {
    print("Spin End");
    isSpinning = false;
    detector.startListening();
    setState(() {});
  }

  void onSpinStart() {
    print("Spin Started");
    isSpinning = true;
    detector.stopListening();
    setState(() {});
  }
}
