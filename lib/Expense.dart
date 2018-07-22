import 'Location.dart';

class Expense {
  int id;
  double amount;
  String name;
  DateTime when;
  Location location;
  String category;

  Expense(this.id, this.amount, this.name, this.when, this.location, this.category);

  String toString(){
    return "{ID: $id, amount: $amount, name: $name, when: $when, category: $category}";
  }

  operator ==(Object other) {
    return other is Expense && other.id == id;
  }
}