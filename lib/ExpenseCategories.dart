import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';

class ExpenseCategories extends StatefulWidget {
  @override
  createState() => new ExpenseCategoriesState();
}

class ExpenseCategoriesState extends State<ExpenseCategories> {
  final _expenses = [12, 13, 14, -15, 16];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(int expense) {
    return new ListTile(
      title: new Text(
        "€ " + expense.toStringAsPrecision(2),
        style: _biggerFont,
      ),
      //subtitle: new Text("test"),
      trailing: new Icon(
        Icons.monetization_on,
        color: expense < 0 ? Colors.red : Colors.green,
      ),
      onTap: () {
        setState(() {});
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _expenses.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.toStringAsPrecision(2),
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles,
              )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add expense'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  void _pushExpense() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
            appBar: new AppBar(
              title: new Text('Add expense'),
            ),
            body: new Column(children: <Widget>[
              new TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  prefixText: '\€',
                ),
                inputFormatters: <TextInputFormatter>[
                  new CurrencyInputFormatter(
                      allowSubdivisions: true, subdivisionMarker: "."),
                ],
                style: const TextStyle(fontSize: 28.0, color: Colors.black87),
              ),
              new GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                children: <Widget>[
                  new FlatButton(
                      onPressed: () {},
                      child:
                          const Icon(Icons.free_breakfast, color: Colors.blue)),
                  new FlatButton(
                      onPressed: () {},
                      child: const Icon(Icons.local_drink, color: Colors.red)),
                  new FlatButton(
                      onPressed: () {},
                      child: const Icon(Icons.fastfood, color: Colors.green)),
                  new FlatButton(
                      onPressed: () {},
                      child: const Icon(Icons.hot_tub, color: Colors.cyan)),
                  new FlatButton(
                      onPressed: () {},
                      child: const Icon(Icons.free_breakfast,
                          color: Colors.indigo)),
                ],
              )
            ]));
      }),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();

          final index = i ~/ 2;

          if (index < _expenses.length) {
            return _buildRow(_expenses[index]);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton(
        child: new Image.network(
            "https://emoji.slack-edge.com/T7738P6P3/bob/0dbb39dcbacebe4e.png"),
        onPressed: () {},
      ),
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: _pushExpense,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}
