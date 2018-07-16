import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
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
                  layoutConfig: new charts.LayoutConfig(
                      leftMarginSpec: new charts.MarginSpec.fixedPixel(32),
                      bottomMarginSpec: new charts.MarginSpec.fixedPixel(5),
                      rightMarginSpec: new charts.MarginSpec.fixedPixel(22),
                      topMarginSpec: new charts.MarginSpec.fixedPixel(20)),
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
        colorFn: (_, __) => hslToRgb(200 / 360, 0.18, 0.9),
        fillPatternFn: (Ordinal data, _) => data.x == hatched
            ? charts.FillPatternType.forwardHatch
            : charts.FillPatternType.solid,
      ),
    ];
  }
}

/// Converts an HSL color value to RGB. Conversion formula
/// adapted from http://en.wikipedia.org/wiki/HSL_color_space.
/// Assumes h, s, and l are contained in the set [0, 1] and
/// returns r, g, and b in the set [0, 255].
///
/// @param   {number}  h       The hue
/// @param   {number}  s       The saturation
/// @param   {number}  l       The lightness
/// @return  {Array}           The RGB representation
///
hslToRgb(h, s, l) {
  var r, g, b;

  if (s == 0) {
    r = g = b = l; // achromatic
  } else {
    var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
    var p = 2 * l - q;
    r = hue2rgb(p, q, h + 1 / 3);
    g = hue2rgb(p, q, h);
    b = hue2rgb(p, q, h - 1 / 3);
  }
  final color = new charts.Color(
      r: (r * 255).round(), g: (g * 255).round(), b: (b * 255).round());

  return color;
}

hue2rgb(p, q, t) {
  if (t < 0) t += 1;
  if (t > 1) t -= 1;
  if (t < 1 / 6) return p + (q - p) * 6 * t;
  if (t < 1 / 2) return q;
  if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
  return p;
}
