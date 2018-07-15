import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Image(
          image: AssetImage("assets/Icon.png"),
        ),
        const Text(
          "\nDeveloped by Anton Danneels and Pieter Delobelle",
          textAlign: TextAlign.center,
        ),
        const Text(
          "\n App icon based on icon by Freepik fromwww.flaticon.com is licensed by CC 3.0 BY", //for some reason they want this and i will place this
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
