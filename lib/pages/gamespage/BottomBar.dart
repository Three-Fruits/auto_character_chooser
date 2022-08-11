import 'package:flutter/material.dart';

class BottomBarComponent extends StatelessWidget {
  const BottomBarComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () =>
                  Scaffold.of(context).openDrawer(), // <-- Opens drawer.
            );
          }),
          Spacer(),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
    );
  }
}
