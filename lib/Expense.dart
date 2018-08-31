import 'Location.dart';
import 'package:rule_engine/src/fact.dart';

class Expense extends Fact {
  int id;
  double amount;
  String name;
  DateTime when;
  Location location;
  String category;

  Expense(
      this.id, this.amount, this.name, this.when, this.location, this.category);

  String toString() {
    return "{ID: $id, amount: $amount, name: $name, when: $when, category: $category}";
  }

  operator ==(Object other) {
    return other is Expense && other.id == id;
  }

  @override
  Map<String, dynamic> attributeMap() {
    var mapping = new Map<String, dynamic>();
    mapping["id"] = id;
    mapping["amount"] = amount;
    mapping["name"] = name;
    mapping["when"] = when;
    mapping["location"] = location;
    mapping["category"] = category;

    return mapping;
  }
}
