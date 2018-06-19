import 'Location.dart';

class Expense {
  double amount;
  String name;
  DateTime when;
  Location location;
  String category;

  Expense(this.amount, this.name, this.when, this.location, this.category);
}