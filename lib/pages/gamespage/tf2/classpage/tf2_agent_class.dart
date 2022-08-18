import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class Tf2Agent {
  String id;
  String name;
  String realName;
  String description;
  String displayIcon;
  String fullPortrait;
  String location;
  String motto;
  String type;
  String speed;
  String health;
  String icon;
  Color color;
  List<String> voiceLines;

  Tf2Agent({
    required this.id,
    required this.name,
    required this.realName,
    required this.description,
    required this.displayIcon,
    required this.location,
    required this.fullPortrait,
    required this.motto,
    required this.type,
    required this.color,
    required this.health,
    required this.speed,
    required this.icon,
    required this.voiceLines,
  });
}

class Tf2Network {
  Future<List<Tf2Agent>> getAgents() async {
    String response = await rootBundle.loadString('assets/tf2/agents.json');
    final data = await json.decode(response);

    List<Tf2Agent> agents = List.empty(growable: true);
    for (var a in data["agents"]) {
      Color gcolor = Color(int.parse(a["color"], radix: 16));
      agents.add(
        Tf2Agent(
          id: a["id"],
          name: a["name"],
          realName: a["realName"],
          description: a["description"],
          displayIcon: a["displayIcon"],
          fullPortrait: a["fullPortrait"],
          location: a["location"],
          motto: a["motto"],
          type: a["type"],
          icon: a["icon"],
          health: a["health"],
          speed: a["speed"],
          color: gcolor,
          voiceLines: (a["voiceLines"] as List<dynamic>).cast<String>(),
        ),
      );
    }
    return agents;
  }
}
