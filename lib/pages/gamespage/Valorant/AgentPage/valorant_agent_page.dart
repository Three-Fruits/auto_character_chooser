// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_character_chooser/pages/Home/NavBar.dart';
import 'package:auto_character_chooser/pages/components/panel_component.dart';
import 'package:auto_character_chooser/pages/gamespage/Valorant/AgentPage/valorant_agent_class.dart';
import 'package:auto_character_chooser/themes/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:shake/shake.dart';

class ValorantAgentPage extends StatefulWidget {
  const ValorantAgentPage({Key? key}) : super(key: key);

  @override
  State<ValorantAgentPage> createState() => _ValorantAgentPageState();
}

class _ValorantAgentPageState extends State<ValorantAgentPage>
    with TickerProviderStateMixin {
  StreamController<int> controller = StreamController<int>();
  MyPanelController panelController = MyPanelController();
  late TabController _tabController;
  var audio = AudioPlayer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ValorantAgent> agents = List.empty(growable: true);
  bool isFirstTime = true;
  bool isLoading = true;
  bool isSpinning = false;
  late ShakeDetector detector;
  int oldId = 0;
  int currentId = 0;

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
    super.dispose();
    detector.stopListening();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    //print("Loading agents starting...");
    _tabController = TabController(length: 5, vsync: this);

    loadAgents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text("Valorant"),
        centerTitle: true,
      ),
      drawer: NavBar(pageName: '/valorant_agents'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyImages.valorantBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: !isLoading
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      color: !isSpinning && !isFirstTime
                          ? agents[currentId]
                              .backgroundGradientColors[2]
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
                  // _panel(agents[oldId]),
                  MyPanel(
                    controller: panelController,
                    floatButtonPressed: () => {spinWheel()},
                    profileImage: CachedNetworkImageProvider(
                      agents[oldId].displayIcon,
                      maxHeight: 100,
                      maxWidth: 100,
                    ),
                    title: Text(agents[oldId].displayName),
                    subtitle: Text(agents[oldId].role.displayName),
                    trailing: Icon(Icons.more_vert),
                    child: panelBody(),
                  ),
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

  Widget panelBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 100,
          height: 5,
          color: Colors.amber,
        ),
        // give the tab bar a height [can change hheight to preferred height]
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: TabBar(
            controller: _tabController,
            // give the indicator a decoration (color and border radius)
            indicator: BoxDecoration(
              color: Colors.amber,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: [
              // first tab [you can add an icon using the icon property]
              Tab(
                icon: CachedNetworkImage(
                  imageUrl: agents[oldId].role.displayIcon,
                ),
              ),

              // second tab [you can add an icon using the icon property]
              for (var i in agents[oldId].ability)
                Tab(
                  icon: CachedNetworkImage(
                    imageUrl: i.displayIcon,
                  ),
                ),
            ],
          ),
        ),
        // tab bar view here
        Container(
          height: 200,
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
          child: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              // first tab bar view widget
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      agents[oldId].description,
                    ),
                  ),
                  Text(
                    agents[oldId].role.displayName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      agents[oldId].role.description,
                    ),
                  ),
                ],
              ),

              for (var i in agents[oldId].ability)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      i.displayName,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        i.description,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
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
    currentId = id;
    controller.add(id + 1);

    fetchAudio();
    onSpinStart();
    setState(() {});
  }

  void fetchAudio() async {
    audio.dispose();
    audio = AudioPlayer();
    await audio
        .setSourceUrl(agents[currentId].voiceLine)
        .whenComplete(() => {});
  }

  void onSpinEnd() {
    print("Spin End");
    audio.resume();
    isSpinning = false;
    detector.startListening();
    oldId = currentId;

    _tabController = TabController(
        length: agents[currentId].ability.length + 1, vsync: this);
    panelController.openPanel();
    setState(() {});
  }

  void onSpinStart() {
    print("Spin Started");
    isSpinning = true;
    setState(() {});
    detector.stopListening();
    panelController.closePanel();
    setState(() {});
  }
}
