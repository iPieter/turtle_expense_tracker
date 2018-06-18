import 'ApplicationDatabase.dart';

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

  sumForAll(DateTime start, DateTime end) async {
    var expenses = await _db.getExpensesInPeriod(start, end);

    return expenses
        .map((expense) => expense.amount)
        .reduce((a, b) => a + b);
  }
}
