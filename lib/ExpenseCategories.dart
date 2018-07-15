import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:turtle/CategoryTile.dart';
import 'ApplicationDatabase.dart';
import 'Expense.dart';
import 'ExpensesChart.dart';
import 'package:tuple/tuple.dart';
import 'Statistics.dart';

class ExpenseCategories extends StatefulWidget {
  @override
  createState() => new ExpenseCategoriesState();
}

class ExpenseCategoriesState extends State<ExpenseCategories> {
  static var _expenses = <Expense>[];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  static final _db = new ApplicationDatabase();

  static final stats = new Statistics();

  Widget _buildList() {
    return new FutureBuilder<List<Tuple3<String, double, double>>>(
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
                            elevation: 0.0,
                            child: new CategoryTile(snapshot.data[index]));
                      } else if (snapshot.data.length == 0 && index == 0) {
                        return new Text("no entries");
                      }
                    });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(flex: 1, child: new PatternForwardHatchBarChart()),
        new Flexible(
          flex: 2,
          child: _buildList(),
        ),
      ],
    );
  }
}
