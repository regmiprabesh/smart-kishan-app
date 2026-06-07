import 'package:smart_kishan/repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  //Check if database exists or not
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _databaseConnection!.setDatabase();

    return _database!;
  }

  //Insert data to Table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //Read data from Table
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  //Read data from Table In ASC
  readDataASC(table) async {
    var connection = await database;
    return await connection.query(
      table,
      orderBy: 'timestamp ASC',
    );
  }

  //Read data by Id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  ///Update data in table
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  ///Update data in table
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.delete(table, where: 'id=?', whereArgs: [itemId]);
  }
}
