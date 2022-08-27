// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_character_chooser/pages/Home/NavBar.dart';
import 'package:auto_character_chooser/pages/components/panel_component.dart';
import 'package:auto_character_chooser/pages/gamespage/tf2/classpage/tf2_agent_class.dart';
import 'package:auto_character_chooser/services/local_data.dart';
import 'package:auto_character_chooser/services/string_color.dart';
import 'package:auto_character_chooser/themes/images.dart';
import 'package:auto_character_chooser/themes/my_colors.dart';
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
  MyPanelController panelController = MyPanelController();
  var audio = AudioPlayer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tf2Agent> agents = List.empty(growable: true);
  bool isFirstTime = true;
  bool isLoading = true;
  bool isSpinning = false;
  late ShakeDetector detector;
  int oldId = 0;
  int currentId = 0;

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
    detector.stopListening();
  }

  @override
  void initState() {
    super.initState();
    //print("Loading agents starting...");

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
                  MyPanel(
                    controller: panelController,
                    floatButtonPressed: () => {spinWheel()},
                    profileImage: CachedNetworkImageProvider(
                      agents[oldId].displayIcon,
                      maxHeight: 100,
                      maxWidth: 100,
                    ),
                    title: Text(agents[oldId].name),
                    subtitle: Text(agents[oldId].type),
                    trailing: Icon(Icons.more_vert),
                    child: panelBody(agents[oldId]),
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

  Widget panelBody(Tf2Agent agent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 100,
          height: 5,
          color: Colors.amber,
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Basic Information"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CachedNetworkImage(
              imageUrl: agent.fullPortrait,
              height: 80,
            ),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Icon: "),
                    ),
                    CachedNetworkImage(imageUrl: agent.icon),
                    Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: Text("Type: " + agent.type),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Health: " + agent.health,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 45),
                      child: Text(
                        "Speed: " + agent.health,
                        style: TextStyle(color: MyColors.yellow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Bio"),
          ),
        ),
        Table(
          border: TableBorder.all(color: MyColors.white),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(130),
            1: FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: Text("Real Name: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                      child: Text(agent.realName)),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("Location of origin: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(agent.location)),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("motto: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('"' + agent.motto + '"')),
                ),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.top,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text("description: "),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(agent.description)),
                ),
              ],
            ),
          ],
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
        .whenComplete(() => {audio.setVolume(MyLocalData.audioVolume / 100)});
    //await audio.release();
  }

  void onSpinEnd() {
    print("Spin End");
    audio.resume();
    isSpinning = false;
    detector.startListening();
    oldId = currentId;
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
