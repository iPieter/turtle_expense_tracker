import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  Widget buildRow(String title, String subtitle,
      {Widget trailing, Function callback}) {
    return ListTile(
      //leading: const Icon(Icons.category),
      title: new Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.blueGrey, letterSpacing: 0.4),
      ),
      trailing: trailing != null ? trailing : new Text(""),
      subtitle: new Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey,
          //color: (_data.item3 > 0) ? Colors.red : Colors.green,
          fontWeight: FontWeight.w100,
        ),
      ),
      onTap: callback != null ? callback : () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Image(
          height: 150.0,
          image: AssetImage(
            "assets/Icon.png",
          ),
        ),
        buildRow("Locations", "Manage frequently visited places",
            trailing: const Icon(Icons.chevron_right), callback: () {
          print("test");
        }),
        buildRow("Categories", "Manage all categories",
            trailing: const Icon(Icons.chevron_right), callback: () {
          print("test");
        }),
        buildRow("Currency", "Select your local currency",
            trailing: new Text(
              "€ 1.000,00",
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w100),
            ), callback: () {
          print("test");
        }),
        buildRow("Authentication", "Require TouchID to open Turtle",
            trailing: new CupertinoSwitch(
              activeColor: Colors.blueGrey,
              value: true,
              onChanged: (bool value) {
                print("togled");
              },
            )),
        Divider(),
        buildRow(
            "Copyright notice", "© 2018 Anton Danneels and Pieter Delobelle."),
        buildRow("Credits",
            "App icon by Freepik from www.flaticon.com, licenced by CC 3.0 BY."),
      ],
    );
  }
}
