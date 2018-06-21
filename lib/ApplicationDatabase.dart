import 'package:sqflite/sqflite.dart' as db_utils;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'Expense.dart';
import 'Location.dart';
import 'package:mutex/mutex.dart';
import 'package:tuple/tuple.dart';

class ApplicationDatabase {
  static final ApplicationDatabase _singleton =
      new ApplicationDatabase._internal();

  db_utils.Database _db;
  Mutex mutex;

  factory ApplicationDatabase() {
    return _singleton;
  }

  _getDB() async {
    await mutex.acquire();
    if (_db == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = [documentsDirectory.path, "app.db"].join();

      print("Deleting old db");
      await db_utils.deleteDatabase(path);

      _db = await db_utils.openDatabase(path, version: 1,
          onCreate: (db_utils.Database db, int version) async {
            print("Creating new db");
                  
              await db.execute(
                  "CREATE TABLE Expense(id INTEGER PRIMARY KEY, amount REAL, name TEXT, date INTEGER, location INTEGER, category TEXT)");
              await db.execute(
                  "CREATE TABLE Location(id INTEGER PRIMARY KEY, name TEXT, lat REAL, lng REAL)");
      }, onOpen: (db_utils.Database db) {
        print("DB opened");
      });

    }
    mutex.release();
    return _db;
  }

  deleteDatabase() async {
    var db = await _getDB();

    await db.rawQuery("DELETE FROM Location");
    await db.rawQuery("DELETE FROM Expense");
  }

  insertExpense(Expense e) async {
    print("Inserting expense");
    var db = await _getDB();
    print("Got DB handle");

    List<Map> loc = await db.rawQuery(
        "SELECT * FROM Location WHERE name = ? AND lat = ? AND lng = ?",
        [e.location.name, e.location.lat, e.location.lng]);

    int ID = 0;
    if (loc.isEmpty) {
      print("Creating a new location entry");
      ID = await db.rawInsert(
          "INSERT INTO Location(name,lat,lng) VALUES(?,?,?)",
          [e.location.name, e.location.lat, e.location.lng]);

      List<Map> locs = await db.rawQuery("SELECT * FROM Location");
      print(locs);
    } else {
      print("Location existed, reusing.");
      ID = loc.elementAt(0)["id"];
    }

    print("Location ID ${ID}");

    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          "INSERT INTO Expense(amount,name,date,location,category) VALUES(?,?,?,?,?)",
          [
            e.amount,
            e.name,
            e.when.millisecondsSinceEpoch,
            ID,
            e.category
          ]);
      print("Created Expense record: $id");
    });
  }

  getExpensesInPeriod(DateTime start, DateTime end) async {
    print("Fetching expenses for period");
    var db = await _getDB();

    List<Map> expenses = await db.rawQuery(
        "SELECT * FROM Expense WHERE date >= ? AND date <= ?",
        [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
    List<Map> locations = await db.rawQuery("SELECT * FROM Location");

    print("Building list");

    return _buildList(expenses, locations);
  }

  _buildList(List<Map> expenses, List<Map> locations) {
    List<Expense> result = new List();

    if( expenses == null || locations == null )
      return result;

    for (var e in expenses) {
      var loc = locations.firstWhere((entry) => entry["id"] == e["location"], orElse: () => null );
      if(loc == null)
        continue;
      Expense expense = new Expense(
          e["amount"],
          e["name"],
          new DateTime.fromMillisecondsSinceEpoch(e["date"]),
          new Location(loc["name"], loc["lat"], loc["lng"]),
          e["category"]);
      result.add(expense);
    
    }

    return result;
  }

  Future<List<Expense>> getAllExpenses() async {
    print("Fetching expenses");
    var db = await _getDB();
    List<Map> expenses = await db.rawQuery("SELECT * FROM Expense");
    List<Map> locations = await db.rawQuery("SELECT * FROM Location");

    print("Building list");

    return _buildList(expenses, locations).reversed.toList();
  }

  Future<List<Tuple2<String,int>>> getCategoryCount() async {
      print("Fetching categories");
      var db = await _getDB();

      var result = new List<Tuple2<String, int>>();
      List<Map> categoryCount =  await db.rawQuery("SELECT category, COUNT(category) FROM Expense GROUP BY category");

      for( var entry in categoryCount ) {
        result.add(new Tuple2(entry["category"], entry["COUNT(category)"]));
      }

      return result;
  }

  ApplicationDatabase._internal() {
    _db = null;
    mutex = new Mutex();
  }
}
