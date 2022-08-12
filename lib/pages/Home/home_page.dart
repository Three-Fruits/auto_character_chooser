// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:auto_character_chooser/pages/Home/NavBar.dart';
import 'package:auto_character_chooser/pages/components/cardbutton_component.dart';
import 'package:auto_character_chooser/themes/images.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random Picker"),
        centerTitle: true,
      ),
      drawer: NavBar(pageName: '/home'),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 30),
              child: Text(
                "Choose a game to play!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amber),
              ),
            ),
            Container(
              height: 200,
              width: 200,
              child: FittedBox(
                fit: BoxFit.contain,
                child: InkWell(
                  onTap: () => {},
                  child: Ink(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      image: DecorationImage(
                        image: AssetImage(MyImages.logoSpinButton),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                "Pick random character\nfor your next game!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amber),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardButtonComponent(
                  event: () => {
                    Navigator.pushReplacementNamed(context, "/valorant_agents")
                  },
                  imageUrl: MyImages.valorantBanner,
                ),
                SizedBox(
                  width: 25,
                ),
                CardButtonComponent(
                  imageUrl: MyImages.valorantBanner,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardButtonComponent(
                  imageUrl: MyImages.valorantBanner,
                ),
                SizedBox(
                  width: 25,
                ),
                CardButtonComponent(
                  imageUrl: MyImages.valorantBanner,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
