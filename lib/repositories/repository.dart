import 'package:sqflite/sqflite.dart';
import 'package:todo/repositories/database_connection.dart';

class Repository {
  DatabaseConnection? _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await _databaseConnection!.setDatabase();
    return _database;
  }

  // create data
  createData(String table, dynamic data) async {
    var connection = await database;
    return await connection!.insert(table, data);
  }

  // read data by column name
  readDataByColumnName(
    String table,
    String columnName,
    dynamic columnValue,
  ) async {
    var connection = await database;
    return await connection!.query(
      table,
      where: '$columnName = ?',
      whereArgs: [columnValue],
      orderBy: 'id DESC',
    );
  }

  // read data by joining tables
  readDataByJoiningTables(String sql, List<dynamic> list) async {
    var connection = await database;
    return await connection!.rawQuery(sql, list);
  }

  // update data
  updateData(String table, dynamic data) async {
    var connection = await database;
    return await connection!.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // delete data
  deleteData(String table, int id) async {
    var connection = await database;
    return await connection!.rawDelete('DELETE FROM $table WHERE id = $id');
  }
}
