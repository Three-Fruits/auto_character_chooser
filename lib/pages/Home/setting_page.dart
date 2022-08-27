import 'package:auto_character_chooser/services/local_data.dart';
import 'package:auto_character_chooser/themes/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Audio'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.volume_up),
                title: Slider(
                  value: MyLocalData.audioVolume,
                  max: 100,
                  divisions: 100,
                  onChanged: (double value) {
                    setState(() {
                      MyLocalData.audioVolume = value;
                    });
                  },
                  onChangeEnd: (value) => {
                    setState(() {
                      MyLocalData().setAudio(value);
                    }),
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
