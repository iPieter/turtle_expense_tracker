import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PatternForwardHatchBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PatternForwardHatchBarChart(this.seriesList, {this.animate});

  factory PatternForwardHatchBarChart.withSampleData() {
    return new PatternForwardHatchBarChart(
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
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 120),
    ];


    return [

      new charts.Series<OrdinalSales, String>(
        id: 'Tablet',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
        fillPatternFn: (OrdinalSales sales, _) =>
            sales.year == "2017" ? charts.FillPatternType.forwardHatch : charts.FillPatternType.solid,
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
