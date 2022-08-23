import 'package:flutter/material.dart';

class CardButtonComponent extends StatelessWidget {
  final VoidCallback? event;
  final String imageUrl;
  final String title;
  final String buttonText;
  const CardButtonComponent({Key? key, this.event, required this.imageUrl,required this.title, this.buttonText = "Pick now!"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: event,
      child: Stack(
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              image: DecorationImage(
                  image: AssetImage(imageUrl), fit: BoxFit.cover),
            ),
          ),
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(.0),
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: event,
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
