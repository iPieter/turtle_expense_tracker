import 'package:sqflite/sqflite.dart' as db_utils;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Expense.dart';

class ApplicationDatabase {
  static final ApplicationDatabase _singleton = new ApplicationDatabase._internal();

  db_utils.Database _db;

  factory ApplicationDatabase() {
    return _singleton;
  }

  _getDB() async {
    if(_db == null) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = [documentsDirectory.path, "app.db"].join();

      _db = await db_utils.openDatabase(path, version: 1,
        onCreate: (db_utils.Database db, int version) {
          db.execute("CREATE TABLE Expense(id INTEGER PRIMARY KEY, amount REAL, name TEXT, date INT, location TEXT, category TEXT)");
      });
    }
    return _db;
  }

  deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = [documentsDirectory.path, "app.db"].join();

    await db_utils.deleteDatabase(path);
  }

  insertExpense( Expense e ) async{
      var db = await _getDB();
  
      await db.transaction((txn) async {
        int id = await txn.rawInsert("INSERT INTO Expense(amount,name,date,location,category) VALUES(?,?,?,?,?)", [e.amount, e.name, e.when.millisecondsSinceEpoch, e.where, e.category]);
        print("Created record: $id");
      });
  }

  getExpensesInPeriod( DateTime start, DateTime end ) async {
    var db = await _getDB();

    List<Expense> expenses = new List();

    List<Map> list = await db.rawQuery("SELECT * FROM Expense WHERE date >= ? AND date <= ?", [ start.millisecondsSinceEpoch, end.millisecondsSinceEpoch ] );

    for( var e in list )
    {
        Expense expense = new Expense(e["amount"], e["name"], new DateTime.fromMicrosecondsSinceEpoch(e["date"]), e["location"], e["category"]);
        expenses.add(expense);
    }

    return expenses;    
  }

  Future<List<Expense>> getAllExpenses() async {
    var db = await _getDB();
    List<Map> list = await db.rawQuery("SELECT * FROM Expense");
    List<Expense> expenses = new List();
    for( var e in list )
    {
        Expense expense = new Expense(e["amount"], e["name"], new DateTime.fromMicrosecondsSinceEpoch(e["date"]), e["location"], e["category"]);
        expenses.add(expense);
    }

    return expenses;
  }

  ApplicationDatabase._internal() {
    _db = null;
  }
}