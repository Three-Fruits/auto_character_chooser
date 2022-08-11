import 'dart:convert';
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
  List<String> backgroundGradientColors = List.empty(growable: true);
  String voiceLine;

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
          List<String> gcolor = List.empty(growable: true);
          for (var i in a["backgroundGradientColors"]) {
            gcolor.add(i);
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
