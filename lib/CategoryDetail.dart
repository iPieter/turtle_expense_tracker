import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:turtle/Statistics.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CategoryDetail extends StatefulWidget {
  final Tuple3 _category;

  const CategoryDetail(this._category);

  @override
  _CategoryDetailState createState() => _CategoryDetailState(_category);
}

class _CategoryDetailState extends State<CategoryDetail> {
  final Tuple3 _category;

  _CategoryDetailState(this._category);

  Widget _buildChart(BuildContext context) {
    var data = new Statistics().getCategoricalSumForWeeks(7, _category.item1);
    return new FutureBuilder<List<TimeSeriesOrdinal>>(
        future: data,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Press button to start');
            case ConnectionState.waiting:
              return new Text('Awaiting result...');
            default:
              if (snapshot.hasError || snapshot.data.length == 0)
                return new Text('Error: ${snapshot.error}');
              else
                return new charts.TimeSeriesChart(
                  _createData(snapshot.data),
                  animate: true,
                  layoutConfig: new charts.LayoutConfig(
                      leftMarginSpec: new charts.MarginSpec.fixedPixel(32),
                      bottomMarginSpec: new charts.MarginSpec.fixedPixel(5),
                      rightMarginSpec: new charts.MarginSpec.fixedPixel(22),
                      topMarginSpec: new charts.MarginSpec.fixedPixel(20)),
                  //barGroupingType: charts.BarGroupingType.grouped,
                );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_category.item1),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(flex: 1, child: _buildChart(context)),
          new Flexible(
            flex: 2,
            child: new Text('€ ' + _category.item2.toString()),
          ),
        ],
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<TimeSeriesOrdinal, DateTime>> _createData(
      List<TimeSeriesOrdinal> data) {
    return [
      new charts.Series<TimeSeriesOrdinal, DateTime>(
        id: '1',
        domainFn: (TimeSeriesOrdinal data, _) => data.x,
        measureFn: (TimeSeriesOrdinal data, _) => data.y,
        data: data,
      ),
    ];
  }
}
