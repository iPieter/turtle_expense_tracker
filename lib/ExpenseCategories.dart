import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:turtle/AboutPage.dart';
import 'package:turtle/CategoryTile.dart';
import 'ApplicationDatabase.dart';
import 'InputExpense.dart';
import 'Expense.dart';
import 'ExpensesList.dart';
import 'ExpensesChart.dart';
import 'package:tuple/tuple.dart';
import 'Statistics.dart';
import 'package:share/share.dart';

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
    return new Scaffold(
      backgroundColor: Colors.white,
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
              leading: const Icon(Icons.bookmark_border),
              title: new Text('Share log file'),
              onTap: () async {
                final RenderBox box = context.findRenderObject();
                final directory = await getApplicationDocumentsDirectory();

                Share
                    .file(
                        mimeType: ShareType.TYPE_FILE,
                        title: 'Log file',
                        path: '${directory.path}/finer.log',
                        text: 'Share the log file')
                    .share(
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);

                Navigator.pop(context);
              },
            ),
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
            new ListTile(
              leading: const Icon(Icons.info),
              title: new Text('About'),
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (_) => new AboutPage()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        elevation: 0.0,
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
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        currentIndex: 1,
        onTap: (i) {
          print(i);
        },
        items: [
          new BottomNavigationBarItem(
              icon: const Icon(Icons.list), title: const Text("Expenses")),
          new BottomNavigationBarItem(
              icon: const Icon(Icons.category),
              title: const Text("Categories")),
          new BottomNavigationBarItem(
              icon: const Icon(
                Icons.add,
              ),
              title: const Text("Add")),
          new BottomNavigationBarItem(
              icon: const Icon(Icons.settings), title: const Text("Settings")),
        ],
      ),
    );
  }
}
