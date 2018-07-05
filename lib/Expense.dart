import 'Location.dart';

class Expense {
  int id;
  double amount;
  String name;
  DateTime when;
  Location location;
  String category;

  Expense(this.id, this.amount, this.name, this.when, this.location, this.category);
}