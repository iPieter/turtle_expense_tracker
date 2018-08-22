import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';
import 'package:geolocation/geolocation.dart' as geoloc;
import 'package:tuple/tuple.dart';
import 'ApplicationDatabase.dart';
import 'Expense.dart';
import 'Location.dart';
import 'DatePicker.dart';

class InputExpense extends StatefulWidget {
  final List<Expense> _expenses;

  InputExpense(this._expenses);

  @override
  createState() => new InputExpenseState(_expenses);
}

class InputExpenseState extends State<InputExpense> {
  final inputController = new TextEditingController();
  final titleInputController = new TextEditingController();
  final loc = geoloc.Geolocation
      .currentLocation(accuracy: geoloc.LocationAccuracy.best)
      .last;

  List<Expense> _expenses;

  InputExpenseState(List<Expense> expenses) {
    _expenses = expenses;
  }
  String _category;
  DateTime _otherDate;

  @override
  void initState() {
    super.initState();
    _category = null;
  }

  Widget getCategoryBtn(String name, Color color, Color color1) {
    return new FlatButton(
        padding: EdgeInsets.only(top: 1.0),
        onPressed: () {
          setState(() {
            _category = _category != name ? name : null;
          });
        },
        child: new Container(
            alignment: Alignment.center,
            width: 69.0,
            height: 69.0,
            decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 7.0,
                      spreadRadius: 0.02,
                      offset: Offset(0.8, 1.3))
                ],
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [color, color1])),
            child: Text(
              name.toUpperCase(),
              textAlign: TextAlign.center,
              style: new TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 10.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFCFCF8)),
            )));
  }

  _showErrorDialog(String text) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Error'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(text),
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
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        title: new TextField(
          controller: inputController,
          autofocus: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          decoration: const InputDecoration(
            contentPadding: const EdgeInsets.only(top: -2.0),
            prefixText: '\€',
            border: InputBorder.none,
            prefixStyle: TextStyle(fontWeight: FontWeight.w200),
          ),
          inputFormatters: <TextInputFormatter>[
            new CurrencyInputFormatter(
                allowSubdivisions: true, subdivisionMarker: "."),
          ],
          style: const TextStyle(fontSize: 28.0, color: Colors.black87),
        ),
        actions: <Widget>[
          new IconButton(
            padding: EdgeInsets.zero,
            icon: new Icon(Icons.today,
                color: _otherDate == null ? Colors.grey : Colors.black),
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minYear: 1970,
                maxYear: 2020,
                initialYear: _otherDate == null
                    ? new DateTime.now().year
                    : _otherDate.year,
                initialMonth: _otherDate == null
                    ? new DateTime.now().month
                    : _otherDate.month,
                initialDate: _otherDate == null
                    ? new DateTime.now().day
                    : _otherDate.day,
                onChanged: (year, month, date) {},
                onConfirm: (year, month, date) {
                  setState(() {
                    _otherDate = new DateTime(year, month, date);
                  });
                },
              );
            },
          ),
          new IconButton(
            icon: new Icon(
              Icons.check,
              color: _category == null ? Colors.grey : Colors.black,
            ),
            onPressed: () async {
              if (_category != null) {
                ApplicationDatabase db = new ApplicationDatabase();

                var result = await loc;
                if (result.isSuccessful) {
                  print(result.location);
                  try {
                    final expense = new Expense(
                        -1,
                        double
                            .parse(inputController.text.replaceFirst(",", ".")),
                        titleInputController.text.isEmpty
                            ? _category
                            : titleInputController.text.trim(),
                        _otherDate == null ? new DateTime.now() : _otherDate,
                        new Location("Paul's bakery", result.location.latitude,
                            result.location.longitude),
                        _category);

                    var achievements = await db.insertExpense(expense);
                    setState(() {});

                    if (achievements.length > 0) {
                      _renderAchievementBadge(achievements[0]);
                    } else {
                      Navigator.pop(context);
                    }
                  } catch (e) {}
                } else {
                  print("Failed");
                  print(result.error);
                  _showErrorDialog("Error: ${result.error.type}");
                }
              } else {
                print("Failed");
                _showErrorDialog("Failed to fetch the current location.");
              }
            },
          ),
        ],
      ),
      body: new Column(children: <Widget>[
        new Divider(),
        new Container(
          height: 100.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              getCategoryBtn("Brood", Color(0xFF36D1DC), Color(0xFF5B86E5)),
              getCategoryBtn("Alcohol", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn(
                  "Vlees en vis", Color(0xFF4776E6), Color(0xFF8E54E9)),
              getCategoryBtn(
                  "Groenten en fruit", Color(0xFF92FE9D), Color(0xFF52c234)),
              getCategoryBtn("Kaas", Color(0xFFAA076B), Color(0xFF61045F)),
              getCategoryBtn("Snacks", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Frieten", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Frisdrank", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Koffie", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn(
                  "Maal-\ntijden", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Vertier", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Shopping", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn(
                  "Gezondheid", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("ICT", Color(0xFFFF416c), Color(0xFFFF4B2B)),
              getCategoryBtn("Andere", Color(0xFFFF416c), Color(0xFFFF4B2B)),
            ],
          ),
        ),
        new Divider(),
      ]),
    );
  }

  void _renderAchievementBadge(Tuple3 achievement) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (_) => new Scaffold(
              body: new SafeArea(
                child: new Column(
                  children: <Widget>[
                    new Text(achievement.toString()),
                    new FlatButton(
                      child: const Text("Awesome"),
                      onPressed: () {
                        Navigator.of(context)..pop()..pop();
                      },
                    )
                  ],
                ),
              ),
            )));
  }
}
