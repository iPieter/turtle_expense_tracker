import 'package:flutter/material.dart';
import 'package:turtle/SettingsPage.dart';
import 'package:turtle/AchievementsList.dart';
import 'package:turtle/Expense.dart';
import 'package:turtle/ExpenseCategories.dart';
import 'package:turtle/ExpensesList.dart';
import 'package:turtle/InputExpense.dart';
import 'package:turtle/Statistics.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static var _expenses = <Expense>[];

  String _title = "Categories";
  int _tab = 1;

  static final stats = new Statistics();

  String getTitle(int index) {
    switch (index) {
      case 0:
        return "Expenses";
      case 1:
        return "Categories";
      case 2:
        return "Achievements";
      case 3:
        return "Settings";
      default:
        return "";
    }
  }

  Widget getBody() {
    switch (_tab) {
      case 0:
        return new ExpensesList();
      case 1:
        return new ExpenseCategories();
      case 2:
        return new AchievementsList();
      case 3:
        return new SettingsPage();
      default:
        return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        title: new Text(_title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (_) => new InputExpense(_expenses)));
              }),
        ],
      ),
      body: getBody(),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,
        currentIndex: _tab,
        onTap: (i) {
          setState(() {
            _title = getTitle(i);
            _tab = i;
          });
        },
        items: [
          new BottomNavigationBarItem(
              icon: const Icon(Icons.list), title: const Text("Expenses")),
          new BottomNavigationBarItem(
              icon: const Icon(Icons.table_chart),
              title: const Text("Categories")),
          new BottomNavigationBarItem(
              icon: const Icon(
                Icons.cake,
              ),
              title: const Text("Achievements")),
          new BottomNavigationBarItem(
              icon: const Icon(Icons.settings), title: const Text("Settings")),
        ],
      ),
    );
  }
}
