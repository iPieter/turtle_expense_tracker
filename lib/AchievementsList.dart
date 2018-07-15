import 'dart:ui';

import 'package:flutter/material.dart';

class AchievementsList extends StatelessWidget {
  Widget buildBadge(String index, String title, String desc) {
    return new Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              child: new Image.asset(
                "assets/badges/$index.png",
                height: 140.0,
              ),
            ),
            new Text(
              title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.blueGrey,
                  letterSpacing: 0.4,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100),
            ),
            new Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.grey,
                  //letterSpacing: 0.4,
                  //fontSize: 18.0,
                  fontWeight: FontWeight.w100),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 0.8,
      crossAxisCount: 2,
      children: <Widget>[
        buildBadge("01", "First spending", "The beginning of a new era"),
        buildBadge("02", "Cold turkey", "Stop spending on a category"),
        buildBadge("03", "Sober monkey", "No booze for a month"),
        buildBadge(
            "04", "30 days", "30 days without an expense for a category"),
        buildBadge("05", "A lot of cheese", "Spent more than € 300 on cheese"),
        buildBadge("06", "Weekly saver",
            "Descrease your spending for 4 weeks in a row"),
      ],
    );
  }
}
