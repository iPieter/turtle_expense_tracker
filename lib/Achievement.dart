import 'package:rule_engine/src/fact.dart';

class Achievement extends Fact {
  String iconIdentifier;
  String title;
  String desc;
  bool earned;
  DateTime earnedTimestamp;

  Achievement(this.iconIdentifier, this.title, this.desc);

  void setEarned() {
    this.earned = true;
    earnedTimestamp = DateTime.now();
  }

  @override
  Map<String, dynamic> attributeMap() {
    var map = Map<String, dynamic>();
    map["iconIdentifier"] = iconIdentifier;
    map["title"] = title;
    map["desc"] = desc;
    map["earned"] = earned;
    map["earnedTimestamp"] = earnedTimestamp;

    return map;
  }
}
