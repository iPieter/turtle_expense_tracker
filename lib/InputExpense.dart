import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'ApplicationDatabase.dart';
import 'Expense.dart';

class InputExpense extends StatefulWidget {
  List<Expense> _expenses;
  String _category;

  InputExpense(List<Expense> expenses) {
    _expenses = expenses;
  }

  @override
  createState() => new InputExpenseState(_expenses);
}

class InputExpenseState extends State<InputExpense> {
  final inputController = new TextEditingController();

  List<Expense> _expenses;

  InputExpenseState(List<Expense> expenses) {
    _expenses = expenses;
  }
  String _category;

  @override
  void initState() {
    super.initState();
    _category = null;
  }

  Widget getCategoryBtn(String name, Color color) {
    return new FlatButton(
                  padding: EdgeInsets.zero,

        onPressed: () {
          setState(() {
            _category = _category != name ? name : null;
          });
        },
        child: new Column(children: <Widget>[
          Icon(Icons.free_breakfast,
              color: _category == null || _category == name
                  ? color
                  : Colors.grey),
          Text(
            name,
            style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
          )
        ]));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add expense'),
          actions: <Widget>[
            new IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                ApplicationDatabase db = new ApplicationDatabase();
                try {
                  final expense = new Expense(
                      double.parse(inputController.text),
                      "test",
                      DateTime.now(),
                      "here",
                      _category);
                  await db.insertExpense(expense);
                  Navigator.pop(context);
                } catch (e) {}
              },
            )
          ],
        ),
        body: new Column(children: <Widget>[
          new TextField(
            controller: inputController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              contentPadding: const EdgeInsets.all(15.0),
              prefixText: '\€',
              border: InputBorder.none,
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
              getCategoryBtn("Alcohol", Colors.red),
              getCategoryBtn("Koffie", Colors.green),
              getCategoryBtn("Brood", Colors.blue),
              getCategoryBtn("Maaltijden", Colors.purple),
              getCategoryBtn("Vlees", Colors.orange),
            ],
          ),
        ]));
  }
}
