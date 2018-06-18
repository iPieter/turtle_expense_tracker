import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'ApplicationDatabase.dart';
import 'Expense.dart';

class InputExpense extends StatefulWidget {
  List<Expense> _expenses;

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

  @override
  Widget build(
    BuildContext context,
  ) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Add expense'),
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
              new FlatButton(
                  onPressed: () {},
                  child: const Icon(Icons.free_breakfast, color: Colors.blue)),
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
                  child:
                      const Icon(Icons.free_breakfast, color: Colors.indigo)),
            ],
          ),
          new RaisedButton(
            child: new Text("add"),
            onPressed: () async {
              ApplicationDatabase db = new ApplicationDatabase();
              final expense = new Expense(
                  double.parse(inputController.text), "test", DateTime.now(), "here", "De Oplossing");
              await db.insertExpense(expense);
              
            },
          )
        ]));
  }
}
