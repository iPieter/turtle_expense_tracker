import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:currency_input_formatter/currency_input_formatter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Expense.dart';

class ExpenseCategories extends StatefulWidget {
  @override
  createState() => new ExpenseCategoriesState();
}

class ExpenseCategoriesState extends State<ExpenseCategories> {
  final _expenses = [new Expense(190.0, "name", DateTime.now(), "ah", "The solution"), new Expense(12.0, "name", DateTime.now(), "ah", "Brood")];
  final _biggerFont = const TextStyle(fontSize: 18.0,);

  Widget _buildRow(Expense expense) {
    return new ListTile(
      dense: false,
      title: new Text(
        expense.category,
        style: _biggerFont,
      ),
      //subtitle: new Text("test"),
      leading: new Icon(
        Icons.crop_square,
        color: Colors.blue,
      ),
      trailing: new Text(
        "€ " + expense.amount.toStringAsFixed(2),
        style: new TextStyle(fontSize: 18.0, color: expense.amount < 0 ? Colors.red : Colors.green),
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
            (expense) {
              return new ListTile(
                title: new Text(
                  expense.amount.toStringAsPrecision(2),
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
              ),
              new MaterialButton(child: new Text("data"), onPressed: (){},)
            ]));
      }),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
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
        title: new Text('Expenses'),
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

/// Bar chart with series legend example
class SimpleSeriesLegend extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleSeriesLegend(this.seriesList, {this.animate});

  factory SimpleSeriesLegend.withSampleData() {
    return new SimpleSeriesLegend(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      // Add the series legend behavior to the chart to turn on series legends.
      // By default the legend will display above the chart.
      behaviors: [new charts.SeriesLegend()],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    final tabletSalesData = [
      new OrdinalSales('2014', 25),
      new OrdinalSales('2015', 50),
      new OrdinalSales('2016', 10),
      new OrdinalSales('2017', 20),
    ];

    final mobileSalesData = [
      new OrdinalSales('2014', 10),
      new OrdinalSales('2015', 15),
      new OrdinalSales('2016', 50),
      new OrdinalSales('2017', 45),
    ];

    final otherSalesData = [
      new OrdinalSales('2014', 20),
      new OrdinalSales('2015', 35),
      new OrdinalSales('2016', 15),
      new OrdinalSales('2017', 10),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabletSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Mobile',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Other',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: otherSalesData,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
