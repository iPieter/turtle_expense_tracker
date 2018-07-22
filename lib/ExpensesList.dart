import 'package:flutter/material.dart';
import 'ApplicationDatabase.dart';
import 'Expense.dart';
import 'DateFormatter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpensesList extends StatefulWidget {
  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {
  static var _expenses = <Expense>[];

  static final _db = new ApplicationDatabase();

  Widget build(BuildContext context) {
    return new FutureBuilder<List<Expense>>(
        future: _db.getAllExpenses(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            //return new Text('Press button to start');
            case ConnectionState.waiting:
            //return new Text('Awaiting result...');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return new ListView.builder(
                    //padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, i) {
                  if (i.isOdd) return new Divider();

                  final index = i ~/ 2;

                  if (index < snapshot.data.length) {
                    var slidableDelegate = new SlidableDrawerDelegate();
                    return new Slidable(
                        key: new Key(index.toString()),
                        delegate: slidableDelegate,
                        actionExtentRatio: 0.25,
                        leftActions: <Widget>[
                          new IconSlideAction(
                            caption: 'Move',
                            color: Colors.blue,
                            icon: Icons.archive,
                            onTap: () => print('Change category'),
                          ),
                        ],
                        rightActions: <Widget>[
                          new IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => {
                                    setState(() {
                                      ApplicationDatabase db =
                                          new ApplicationDatabase();
                                      db.deleteExpense(snapshot.data[index]);
                                    }): i
                                  }),
                        ],
                        child: _buildRow(snapshot.data[index]));
                  } else if (snapshot.data.length == 0 && i == 0) {
                    return new Text("no entries");
                  }
                });
          }
        });
  }

  Widget _buildRow(Expense expense) {
    return new ListTile(
      dense: false,
      title: expense.name != null
          ? Text(
              expense.name,
              //style: _biggerFont,
            )
          : Text(
              "Unknown name",
              style: const TextStyle(color: Colors.redAccent),
            ),
      subtitle: expense.when != null && expense.category != null
          ? Text(
              expense.category +
                  " • " +
                  DateFormatter.prettyPrint(expense.when),
              //style: _biggerFont,
            )
          : Text(
              "Unknown date",
              style: const TextStyle(color: Colors.redAccent),
            ),
      //subtitle: new Text("test"),

      trailing: new Text(
        "€ " + expense.amount.toStringAsFixed(2),
        style: new TextStyle(
            fontSize: 18.0,
            color: expense.amount > 0 ? Colors.red : Colors.green),
      ),
      onTap: () {
        setState(() {});
        showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return new AlertDialog(
                title: new Text('Info'),
                content: new SingleChildScrollView(
                  child: new ListBody(
                    children: <Widget>[
                      new Text(expense.name),
                      new Text(expense.location.name),
                      new Text(expense.when.toIso8601String()),
                      new Text("${expense.amount} €"),
                      new IconButton(
                        icon: new Icon(Icons.delete_forever),
                        tooltip: 'Delete expense',
                        onPressed: () {
                          setState(() {
                            ApplicationDatabase db = new ApplicationDatabase();
                            db.deleteExpense(expense);
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
    );
  }
}
