import 'RandomWords.dart';
import 'package:flutter/material.dart';

void main() => runApp(new Turtle());

class Turtle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //remove shitty debug banner
      title: 'Startup Name Generator',
      home: new RandomWords(),
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
    );
  }
}