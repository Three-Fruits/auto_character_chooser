// To parse this JSON data, do
//
//     final tf2Agent = tf2AgentFromJson(jsonString);
import 'dart:convert';

import 'package:flutter/services.dart';

class ApexNetwork {
  Future<List<ApexAgent>> getAgents() async {
    String response = await rootBundle.loadString('assets/tf2/agents.json');
    var data = json.decode(response);
    List<ApexAgent> agents =
        List<ApexAgent>.from(data["agents"].map((x) => ApexAgent.fromJson(x)));
    return agents;
  }
}

class ApexAgent {
  ApexAgent({
    required this.id,
    required this.name,
    required this.realName,
    required this.description,
    required this.displayIcon,
    required this.fullPortrait,
    required this.location,
    required this.motto,
    required this.type,
    required this.icon,
    required this.health,
    required this.speed,
    required this.color,
    required this.voiceLines,
  });

  final String id;
  final String name;
  final String realName;
  final String description;
  final String displayIcon;
  final String fullPortrait;
  final String location;
  final String motto;
  final String type;
  final String icon;
  final String health;
  final String speed;
  final String color;
  final List<String> voiceLines;

  factory ApexAgent.fromRawJson(String str) =>
      ApexAgent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApexAgent.fromJson(Map<String, dynamic> json) => ApexAgent(
        id: json["id"],
        name: json["name"],
        realName: json["realName"],
        description: json["description"],
        displayIcon: json["displayIcon"],
        fullPortrait: json["fullPortrait"],
        location: json["location"],
        motto: json["motto"],
        type: json["type"],
        icon: json["icon"],
        health: json["health"],
        speed: json["speed"],
        color: json["color"],
        voiceLines: List<String>.from(json["voiceLines"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "realName": realName,
        "description": description,
        "displayIcon": displayIcon,
        "fullPortrait": fullPortrait,
        "location": location,
        "motto": motto,
        "type": type,
        "icon": icon,
        "health": health,
        "speed": speed,
        "color": color,
        "voiceLines": List<dynamic>.from(voiceLines.map((x) => x)),
      };
}
