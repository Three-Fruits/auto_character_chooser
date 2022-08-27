import 'package:shared_preferences/shared_preferences.dart';

class MyLocalData {
  static late SharedPreferences prefs;

  //audio volume
  static double audioVolume = 10.0;

  void setAudio(double value) async {
    audioVolume = value;
    await prefs.setDouble("audioVolume", value);
  }

  Future<void> initLocalData() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loadLocalData() async {
    // Save an boolean value to 'isAudio' key.
    audioVolume = await prefs.getDouble('audioVolume') ?? 100;
  }

  Future<void> setLocalData(String key, String value) async {
    prefs.setString(key, value);
  }
}
