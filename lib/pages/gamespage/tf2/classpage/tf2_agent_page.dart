// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_character_chooser/pages/Home/NavBar.dart';
import 'package:auto_character_chooser/pages/gamespage/tf2/classpage/tf2_agent_class.dart';
import 'package:auto_character_chooser/services/string_color.dart';
import 'package:auto_character_chooser/themes/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shake/shake.dart';

class Tf2AgentPage extends StatefulWidget {
  const Tf2AgentPage({Key? key}) : super(key: key);

  @override
  State<Tf2AgentPage> createState() => _Tf2AgentPageState();
}

class _Tf2AgentPageState extends State<Tf2AgentPage>
    with TickerProviderStateMixin {
  StreamController<int> controller = StreamController<int>();
  var audio = AudioPlayer();
  late AnimationController panelButtonController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DraggableScrollableController dragController =
      DraggableScrollableController();
  List<Tf2Agent> agents = List.empty(growable: true);
  bool isFirstTime = true;
  bool isLoading = true;
  bool isSpinning = false;
  late ShakeDetector detector;
  int oldId = 0;
  int currentId = 0;
  double initialSize = 0;
  double minSize = 0;

  void loadAgents() async {
    isLoading = true;
    agents = await Tf2Network().getAgents();
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
    panelButtonController.dispose();
    detector.stopListening();
  }

  @override
  void initState() {
    super.initState();
    //print("Loading agents starting...");
    panelButtonController =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);

    loadAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        
        title: Text("Team Fortress 2"),
        centerTitle: true,
      ),
      drawer: NavBar(pageName: '/tf2_agents'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyImages.tf2background),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: !isLoading
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      color: !isSpinning && !isFirstTime
                          ? ColorConvert.converColor(agents[currentId].color)
                              .withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: !isFirstTime,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: FortuneBar(
                          rotationCount: 40,
                          duration: Duration(seconds: 5),
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
                                  padding: EdgeInsets.only(top: 10),
                                  color: ColorConvert.converColor(agent.color),
                                  height: double.infinity,
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: agent.fullPortrait,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _panel(agents[oldId]),
                  if (isFirstTime)
                    InkWell(
                      onTap: () => spinWheel(),
                      child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        color: Colors.grey.withOpacity(0.5),
                        child: Text(
                          "Press here or \nShake device to shuffle!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )
            : Center(
                child: Text("Loading..."),
              ),
      ),
    );
  }

  Widget _panel(Tf2Agent agent) {
    return DraggableScrollableSheet(
      controller: dragController,
      initialChildSize: initialSize,
      maxChildSize: 0.75,
      minChildSize: minSize,
      snap: true,
      builder: (context, scrollController) {
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              ListView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                shrinkWrap: true,
                children: [
                  InkWell(
                    onTap: () => {
                      openPanel(full: dragController.size < 0.2),
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                agent.displayIcon,
                                maxHeight: 100,
                                maxWidth: 100,
                              ),
                            ),
                            title: Text(agent.name),
                            subtitle: Text(agent.type),
                            trailing: Icon(Icons.more_vert),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.close_menu,
                            progress: AnimationController(
                              value: 1 - calculatePanelHeightRatio(),
                              vsync: this,
                            ),
                            semanticLabel: 'Show menu',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: 100,
                    height: 5,
                    color: Colors.amber,
                  ),
                ],
              ),
              FloatingActionButton(
                  child: ImageIcon(
                    AssetImage(MyImages.shuffle),
                  ),
                  onPressed: () {
                    spinWheel();
                  }),
            ],
          ),
        );
      },
    );
  }

  void spinWheel({int id = -1}) {
    isFirstTime = false;
    if (id == -1) {
      var rng = Random();
      id = rng.nextInt(agents.length);
    }
    if (id >= agents.length) {
      id = 0;
    }
    if (id < 0) {
      id = agents.length - 1;
    }
    print(id);
    currentId = id;
    controller.add(id + 1);
    fetchAudio();
    onSpinStart();
    setState(() {});
  }

  void fetchAudio() async {
    audio.dispose();
    audio = AudioPlayer();
    var rng = Random();
    var rngid = rng.nextInt(agents[currentId].voiceLines.length);
    await audio
        .setSourceUrl(agents[currentId].voiceLines[rngid])
        .whenComplete(() => {});
    //await audio.release();
  }

  void onSpinEnd() {
    print("Spin End");
    audio.resume();
    isSpinning = false;
    detector.startListening();
    oldId = currentId;
    openPanel();
    setState(() {});
  }

  void onSpinStart() {
    print("Spin Started");
    isSpinning = true;
    setState(() {});
    detector.stopListening();
    closePanel();
    setState(() {});
  }

  void openPanel({bool full = false}) {
    var temp = 0.15;
    if (full) {
      temp = 0.75;
    }
    dragController
        .animateTo(temp,
            duration: Duration(milliseconds: 200), curve: Curves.easeInCubic)
        .then((value) => setState(() => {
              initialSize = temp,
              minSize = 0.15,
            }));
  }

  void closePanel() {
    minSize = 0;
    setState(() {});
    dragController
        .animateTo(0.00,
            duration: Duration(milliseconds: 200), curve: Curves.easeInCubic)
        .then((value) => setState(() => initialSize = 0));
  }

  double calculatePanelHeightRatio() {
    var OldRange = (0.75 - 0.15);
    var NewRange = 1;
    var NewValue = (((dragController.size - 0.15) * NewRange) / OldRange);
    return NewValue;
  }
}
