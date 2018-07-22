import 'package:sqflite/sqflite.dart' as db_utils;
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'Expense.dart';
import 'Location.dart';
import 'package:mutex/mutex.dart';
import 'package:tuple/tuple.dart';
import 'package:logging/logging.dart';

class ApplicationDatabase {
  static final ApplicationDatabase _singleton =
      new ApplicationDatabase._internal();

  final Logger _log = new Logger('Turtle');

  db_utils.Database _db;
  Mutex mutex;
  List<Expense> localExpenses;
  DateTime startDate;
  DateTime endDate;

  factory ApplicationDatabase() {
    return _singleton;
  }

  _getDB() async {
    await mutex.acquire();
    if (_db == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = [documentsDirectory.path, "app.db"].join("/");

      //print("Deleting old db");
      //await db_utils.deleteDatabase(path);

      _db = await db_utils.openDatabase(path, version: 1,
          onCreate: (db_utils.Database db, int version) async {
        _log.info("Creating new db");

        await db.execute(
            "CREATE TABLE Expense(id INTEGER PRIMARY KEY, amount REAL, name TEXT, date INTEGER, location INTEGER, category TEXT)");
        await db.execute(
            "CREATE TABLE Location(id INTEGER PRIMARY KEY, name TEXT, lat REAL, lng REAL)");
      }, onOpen: (db_utils.Database db) {
        _log.finest("DB opened");
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

  deleteExpense(Expense e) async {
    _log.finest("Deleting expense $e");
  
    var db = await _getDB();

    await db.rawQuery("DELETE FROM Expense WHERE id = ?", [e.id]);
    localExpenses.removeWhere((exp) => exp.id == e.id );
  }

  insertExpense(Expense e) async {
    _log.finest("Inserting expense");
    var db = await _getDB();
    await mutex.acquire();
    _log.finest("Got DB handle");

    List<Map> loc = await db.rawQuery(
        "SELECT * FROM Location WHERE name = ? AND lat = ? AND lng = ?",
        [e.location.name, e.location.lat, e.location.lng]);

    int ID = 0;
    if (loc.isEmpty) {
      _log.finest("Creating a new location entry");
      ID = await db.rawInsert(
          "INSERT INTO Location(name,lat,lng) VALUES(?,?,?)",
          [e.location.name, e.location.lat, e.location.lng]);

      List<Map> locs = await db.rawQuery("SELECT * FROM Location");
      _log.finest(locs);
    } else {
      _log.finest("Location existed, reusing.");
      ID = loc.elementAt(0)["id"];
    }

    _log.finest("Location ID ${ID}");

    await db.transaction((txn) async {
      int id = await txn.rawInsert(
          "INSERT INTO Expense(amount,name,date,location,category) VALUES(?,?,?,?,?)",
          [e.amount, e.name, e.when.millisecondsSinceEpoch, ID, e.category]);
      e.id = id;
      localExpenses.add(e);
      _log.finest("Created Expense record: $id");
    });

    mutex.release();
  }

  getExpensesInPeriod(DateTime start, DateTime end) async {
    _log.finest("Fetching expenses for period");

    _log.finest("Requested:");
    _log.finest(start);
    _log.finest(end);

    _log.finest("Current:");
    _log.finest(startDate);
    _log.finest(endDate);

    if (start.isBefore(startDate) || end.isAfter(endDate)) {
      _log.finest("Using DB");
      var db = await _getDB();

      List<Map> expenses = await db.rawQuery(
          "SELECT * FROM Expense WHERE date >= ? AND date <= ? ORDER BY date",
          [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);
      List<Map> locations = await db.rawQuery("SELECT * FROM Location");

      _log.finest("Building list");

      var expensesInPeriod = _buildList(expenses, locations).reversed.toList();

      expensesInPeriod.forEach((e) {
        if (e.when.isAfter(startDate) || e.when.isBefore(endDate)) {
          if(!localExpenses.contains(e))
            localExpenses.add(e);
        }
      });

      if (start.isBefore(startDate)) startDate = start;

      if (end.isAfter(endDate)) endDate = end;

      localExpenses.sort((e1,e2) => e1.when.compareTo(e2.when));

      return expensesInPeriod;
    }
    _log.finest("Using local cache");
    // Note: +-1s to have the same result as the db query.
    return localExpenses
        .where((e) => e.when.isAfter(start.subtract(const Duration(seconds: 1))) && e.when.isBefore(end.add(const Duration(seconds: 1))))
        .toList();
  }

  List<Expense> _buildList(List<Map> expenses, List<Map> locations) {
    List<Expense> result = new List();

    if (expenses == null || locations == null) return result;

    for (var e in expenses) {
      var loc = locations.firstWhere((entry) => entry["id"] == e["location"],
          orElse: () => null);
      if (loc == null) continue;
      Expense expense = new Expense(
          e["id"],
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
    _log.finest("Fetching expenses");
    var db = await _getDB();
    List<Map> expenses = await db.rawQuery("SELECT * FROM Expense ORDER BY date");
    List<Map> locations = await db.rawQuery("SELECT * FROM Location");

    _log.finest("Building list");

    localExpenses = _buildList(expenses, locations).reversed.toList();

    if (localExpenses.length > 0) {
      startDate =
          localExpenses.reduce((a, b) => a.when.isBefore(b.when) ? a : b).when;
      endDate = new DateTime.now();

      _log.fine("Current:");
      _log.finest(startDate);
      _log.finest(endDate);
    }

    return localExpenses;
  }

  Future<List<Tuple2<String, double>>> getCategoryCount(
      DateTime start, DateTime end) async {
    _log.finest("Fetching categories");
    if (start.isBefore(startDate) || end.isAfter(endDate)) {
      _log.finest("Using DB");
      var db = await _getDB();

      var result = new List<Tuple2<String, double>>();
      List<Map> categoryCount = await db.rawQuery(
          "SELECT category, amount, SUM(amount) FROM Expense WHERE date >= ? AND date <= ? GROUP BY category",
          [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch]);

      for (var entry in categoryCount) {
        result.add(new Tuple2(entry["category"], entry["SUM(amount)"]));
      }

      return result;
    }
    _log.finest("Using cache");

    // Note: +-1s to have the same result as the db query.
    var list = localExpenses
        .where((e) => e.when.isAfter(start.subtract(const Duration(seconds: 1))) && e.when.isBefore(end.add(const Duration(seconds: 1))));

    _log.finest(list);

    List<String> cats = list.map((e) => e.category).toList();
    List<String> uniqueCats = new Set<String>.from(cats).toList();

    _log.finest(uniqueCats);

    return uniqueCats
        .map((e) => new Tuple2<String, double>(
            e,
            list.fold(0.0,
                (prev, cur) => prev + (cur.category == e ? cur.amount : 0.0))))
        .toList();
  }

  ApplicationDatabase._internal() {
    _db = null;
    mutex = new Mutex();
    localExpenses = new List();
    startDate = new DateTime.now();
    endDate = new DateTime.fromMillisecondsSinceEpoch(0);
  }
}
