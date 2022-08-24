import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ValorantAgent {
  String uuid;
  String displayName;
  String description;
  String displayIcon;
  String? bustPortrait;
  String fullPortrait;
  String background;
  bool isPlayableCharacter;
  List<Color> backgroundGradientColors = List.empty(growable: true);
  String voiceLine;
  Role role;
  List<Ability> ability;

  factory ValorantAgent.fromJson(Map<String, dynamic> json) {
    List<Color> gcolor = List.empty(growable: true);
    for (var i in json["backgroundGradientColors"]) {
      gcolor.add(Color(int.parse(i, radix: 16)));
    }
    Role r = Role(
      uuid: json["role"]["uuid"],
      displayName: json["role"]["displayName"],
      displayIcon: json["role"]["displayIcon"],
      description: json["role"]["description"],
    );
    List<Ability> ab = List.empty(growable: true);
    for (var i in json["abilities"]) {
      if (i["displayIcon"] == null) continue;
      ab.add(
        Ability(
          slot: i["slot"],
          displayName: i["displayName"],
          description: i["description"],
          displayIcon: i["displayIcon"],
        ),
      );
    }
    return ValorantAgent(
      uuid: json["uuid"],
      displayName: json["displayName"],
      description: json["description"],
      displayIcon: json["displayIcon"],
      fullPortrait: json["fullPortrait"],
      bustPortrait: json["bustPortrait"],
      background: json["background"],
      isPlayableCharacter: json["isPlayableCharacter"],
      backgroundGradientColors: gcolor,
      voiceLine: json["voiceLine"]["mediaList"][0]["wave"],
      role: r,
      ability: ab,
    );
  }

  ValorantAgent({
    required this.uuid,
    required this.displayName,
    required this.description,
    required this.displayIcon,
    this.bustPortrait,
    required this.fullPortrait,
    required this.background,
    required this.isPlayableCharacter,
    required this.backgroundGradientColors,
    required this.voiceLine,
    required this.role,
    required this.ability,
  });
}

class Role {
  String uuid;
  String displayName;
  String description;
  String displayIcon;

  Role({
    required this.uuid,
    required this.displayName,
    required this.description,
    required this.displayIcon,
  });
}

class Ability {
  String slot;
  String displayName;
  String description;
  String displayIcon;

  Ability({
    required this.slot,
    required this.displayName,
    required this.description,
    required this.displayIcon,
  });
}

class ValorantAgentNetwork {
  Future<List<ValorantAgent>> getAgents() async {
    String response =
        await rootBundle.loadString('assets/valorant/agents.json');
    var data = json.decode(response);
    List<ValorantAgent> agents = List<ValorantAgent>.from(
        data["data"].map((x) => ValorantAgent.fromJson(x)));
    return agents;
  }
}
