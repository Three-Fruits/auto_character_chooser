import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ValorantAgent {
  String uuid;
  String displayName;
  String description;
  String displayIcon;
  String bustPortrait;
  String fullPortrait;
  String background;
  bool isPlayableCharacter;
  List<Color> backgroundGradientColors = List.empty(growable: true);
  String voiceLine;
  Role role;
  List<Ability> ability;

  ValorantAgent({
    required this.uuid,
    required this.displayName,
    required this.description,
    required this.displayIcon,
    required this.bustPortrait,
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
    try {
      Response response = await get(
        Uri.parse("https://valorant-api.com/v1/agents"),
      );
      Map data = jsonDecode(response.body);

      if (data['status'] == 200) {
        List<ValorantAgent> agents = List.empty(growable: true);
        for (var a in data["data"]) {
          if (!a["isPlayableCharacter"]) continue;
          List<Color> gcolor = List.empty(growable: true);
          for (var i in a["backgroundGradientColors"]) {
            gcolor.add(Color(int.parse(i, radix: 16)));
          }
          Role r = Role(
            uuid: a["role"]["uuid"],
            displayName: a["role"]["displayName"],
            displayIcon: a["role"]["displayIcon"],
            description: a["role"]["description"],
          );
          List<Ability> ab = List.empty(growable: true);
          for (var i in a["abilities"]) {
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
          agents.add(
            ValorantAgent(
              uuid: a["uuid"],
              displayName: a["displayName"],
              description: a["description"],
              displayIcon: a["displayIcon"],
              bustPortrait: a["bustPortrait"],
              fullPortrait: a["fullPortrait"],
              background: a["background"],
              isPlayableCharacter: a["isPlayableCharacter"],
              backgroundGradientColors: gcolor,
              voiceLine: a["voiceLine"]["mediaList"][0]["wave"],
              role: r,
              ability: ab,
            ),
          );
        }
        return agents;
      } else {
        print(data['error']['message']);
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
      return List.empty();
    }
  }
}
