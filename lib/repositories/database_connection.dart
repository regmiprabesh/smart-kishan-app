import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_smartkishan');
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    // await database.execute('DROP TABLE products');
    // await database.execute('DROP TABLE daily_activity');
    // await database.execute('DROP TABLE notes');
    // await database.execute('DROP TABLE sync');
    // await database.execute(
    //     'CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT,stock INTEGER,unit_id INTEGER, description TEXT,is_sellable TINYINT(1), user_id INTEGER, date TEXT)');
    // await database.execute(
    //     'CREATE TABLE daily_activity (id INTEGER PRIMARY KEY, title TEXT,quantity INTEGER,type String, description TEXT,product_id INTEGER,income_amount FLOAT,expense_amount FLOAT, user_id INTEGER, date TEXT)');
    // await database.execute(
    //     'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, description TEXT,priority INTEGER,user_id INTEGER, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)');
    // await database.execute(
    //     'CREATE TABLE sync (id INTEGER PRIMARY KEY, object_id INTEGER,object_type TEXT, change_type TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)');
    return database;
  }

  _onCreate(Database database, int version) async {
    await database.execute(
        'CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT,stock INTEGER,unit_id INTEGER, description TEXT,is_sellable TINYINT(1), user_id INTEGER, date TEXT)');
    await database.execute(
        'CREATE TABLE daily_activity (id INTEGER PRIMARY KEY, title TEXT,quantity INTEGER,type String, description TEXT,product_id INTEGER,income_amount FLOAT,expense_amount FLOAT, user_id INTEGER, date TEXT)');
    await database.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY,server_id INTEGER, title TEXT, description TEXT,priority INTEGER,user_id INTEGER, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)');
    await database.execute(
        'CREATE TABLE sync (id INTEGER PRIMARY KEY, object_id INTEGER,object_type TEXT, change_type TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP)');
  }
}
