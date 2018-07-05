import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:turtle/CategoryDetail.dart';

class CategoryTile extends StatefulWidget {
  final Tuple3 _data;

  const CategoryTile(this._data);

  @override
  _CategoryTileState createState() => _CategoryTileState(_data);
}

class _CategoryTileState extends State<CategoryTile> {
  final Tuple3 _data;

  _CategoryTileState(this._data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.category),
      title: new Text(_data.item1),
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
                      color: (_data.item3 > 0) ? Colors.red : Colors.green),
                ),
                new Text(
                  (_data.item3 > 0 ? "+" : "") +
                      _data.item3.toStringAsFixed(0) +
                      " %",
                  style: TextStyle(
                      color: (_data.item3 > 0) ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w100,
                      fontSize: 10.0),
                ),
              ],
            ),
            //const Icon(Icons.chevron_right),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
            new MaterialPageRoute(builder: (_) => new CategoryDetail(_data)));
      },
    );
  }
}
