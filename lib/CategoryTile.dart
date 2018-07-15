import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:turtle/CategoryDetail.dart';

class CategoryTile extends StatelessWidget {
  final Tuple3 _data;

  const CategoryTile(this._data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: const Icon(Icons.category),
      title: generateTitle(),
      trailing: new SizedBox(
        width: 100.0,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  " € " + _data.item2.toStringAsFixed(2) + " ",
                  style: TextStyle(
                      color: (_data.item3 > 0) ? Colors.red : Colors.green,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
            //const Icon(Icons.chevron_right),
          ],
        ),
      ),
      subtitle: new Text(
        getSubtitle(_data.item3),
        style: TextStyle(
          color: Colors.grey,
          //color: (_data.item3 > 0) ? Colors.red : Colors.green,
          fontWeight: FontWeight.w100,
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (_) => new CategoryDetail(_data)));
      },
    );
  }

  generateTitle() {
    if (_data.item3 < -0.5) {
      return new Row(children: <Widget>[
        new Text(
          _data.item1.toUpperCase(),
          style: const TextStyle(color: Colors.blueGrey, letterSpacing: 0.4),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
            child: const Icon(
              Icons.sentiment_satisfied,
              size: 18.0,
              color: Colors.green,
            ))
      ]);
    }
    return new Row(children: <Widget>[
      new Text(
        _data.item1.toUpperCase(),
        style: const TextStyle(color: Colors.blueGrey, letterSpacing: 0.4),
      )
    ]);
  }
}

String getSubtitle(double percentage) {
  final pr = percentage.abs().toStringAsFixed(0);
  if (percentage == double.infinity)
    return "";
  else if (percentage > 0.1)
    return "$pr % meer uitgegeven";
  else if (percentage < -0.1)
    return "$pr % bespaard";
  else
    return "ongeveer gelijk";
}
