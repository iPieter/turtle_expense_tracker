import 'ApplicationDatabase.dart';
import 'dart:async';

class Statistics {
  ApplicationDatabase _db;

  Statistics() {
    _db = new ApplicationDatabase();
  }

  sumForCategory(DateTime start, DateTime end, String category) async {
    var expenses = await _db.getExpensesInPeriod(start, end);

    return expenses
        .where((expense) => expense.category == category)
        .map((expense) => expense.amount)
        .reduce((a, b) => a + b);
  }

  Future<double> sumForAll(DateTime start, DateTime end) async {
    var expenses = await _db.getExpensesInPeriod(start, end);
    if (expenses.length > 0)
      return expenses.map((expense) => expense.amount).reduce((a, b) => a + b);
    else
      return new Future(() {
        return 0.0;
      });
  }

  List<DateTime> getWeekDates(int n) {
    var now = new DateTime.now();

    var lastWeekStart =
        now.subtract(new Duration(days: (now.weekday + 6 + 7 * (n - 1))));

    return [lastWeekStart, lastWeekStart.add(new Duration(days: 7))];
  }

  Future<List<Ordinal>> getSumForWeeks(int numberOfWeeks) async {
    List<Ordinal> data = <Ordinal>[];

    for (var i = numberOfWeeks; i >= 0; i--) {
      var week = getWeekDates(i);
      Ordinal o = new Ordinal(
          week[0].day.toString() + "/" + week[0].month.toString(),
          await sumForAll(week[0], week[1]));
      data.add(o);
    }
    return data;
  }
}

class Ordinal {
  final String x;
  final double y;

  Ordinal(this.x, this.y);
}
