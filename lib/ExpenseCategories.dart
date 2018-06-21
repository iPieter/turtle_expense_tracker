import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';
import 'ApplicationDatabase.dart';
import 'InputExpense.dart';
import 'Expense.dart';
import 'ExpensesList.dart';
import 'ExpensesChart.dart';
import 'package:tuple/tuple.dart';
import 'Statistics.dart';

class ExpenseCategories extends StatefulWidget {
  @override
  createState() => new ExpenseCategoriesState();
}

class ExpenseCategoriesState extends State<ExpenseCategories> {
  static var _expenses = <Expense>[];
  final _biggerFont = const TextStyle(
    fontSize: 18.0,
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static final _db = new ApplicationDatabase();

  static final stats = new Statistics();

  Widget _buildList() {
    return new FutureBuilder<List<Tuple3<String, double,double>>>(
        future: stats.getWeekData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            //return new Text('Press button to start');
            case ConnectionState.waiting:
            //return new Text('Awaiting result...');
            default:
              if (snapshot.hasError || snapshot.data == null)
                return new Text('Error: ${snapshot.error}');
              else
                return new ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemBuilder: (context, index) {
                      if (index < snapshot.data.length) {
                        return new Card(
                            child: new ListTile(
                                leading: const Icon(Icons.category),
                                title: new Text(snapshot.data[index].item1),
                                trailing: new SizedBox(
                                  width: 100.0,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      
                                      new Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Text(
                                            " €" +
                                                snapshot.data[index].item2
                                                    .toString() +
                                                " ",
                                            style: TextStyle(
                                                color: (snapshot.data[index].item3 > 0) ? Colors.red : Colors.green),
                                          ),
                                          
                                          new Text(
                                            (snapshot.data[index].item3 > 0 ? "+" : "") +
                                                snapshot.data[index].item3
                                                    .toStringAsFixed(2) + " %",
                                            style: TextStyle(
                                                color: (snapshot.data[index].item3 > 0) ? Colors.red : Colors.green,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 10.0),
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.unfold_more),
                                    ],
                                  ),
                                )));
                      } else if (snapshot.data.length == 0 && index == 0) {
                        return new Text("no entries");
                      }
                    });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: new Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: new ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            new DrawerHeader(
              child: new Text('Turtle',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  )),
              decoration: new BoxDecoration(
                color: Colors.lightBlue,
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.list),
              title: new Text('View All Expenses'),
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (_) => new ExpensesList()));
              },
            ),
            new Divider(),
            new ListTile(
              leading: const Icon(Icons.delete_forever),
              title: new Text('Clear Database'),
              onTap: () {
                setState(() {
                  _db.deleteDatabase();
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Image.network(
            "https://emoji.slack-edge.com/T7738P6P3/bob/0dbb39dcbacebe4e.png"),
        onPressed: () {},
      ),
      appBar: new AppBar(
        title: new Text('Expenses'),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (_) => new InputExpense(_expenses)));
              }),
        ],
        leading: new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(flex: 1, child: new PatternForwardHatchBarChart()),
          new Flexible(
            flex: 2,
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
