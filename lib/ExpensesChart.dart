import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Expense.dart';
import 'Statistics.dart';

class PatternForwardHatchBarChart extends StatelessWidget {
  final bool animate;

  PatternForwardHatchBarChart({this.animate});

  @override
  Widget build(BuildContext context) {
    var data = new Statistics().getSumForWeeks(7);
    return new FutureBuilder<List<Ordinal>>(
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
                return new charts.BarChart(
                  _createData(snapshot.data, snapshot.data[7].x),
                  animate: animate,
                  barGroupingType: charts.BarGroupingType.grouped,
                );
          }
        });
  }

  /// Create series list with multiple series
  static List<charts.Series<Ordinal, String>> _createData(
      List<Ordinal> data, String hatched) {
    return [
      new charts.Series<Ordinal, String>(
        id: '1',
        domainFn: (Ordinal data, _) => data.x,
        measureFn: (Ordinal data, _) => data.y,
        data: data,
        fillPatternFn: (Ordinal data, _) => data.x == hatched
            ? charts.FillPatternType.forwardHatch
            : charts.FillPatternType.solid,
      ),
    ];
  }
}
