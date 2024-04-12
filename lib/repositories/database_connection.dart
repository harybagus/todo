import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'todo.db');
    int version = 1;
    var database = await openDatabase(
      path,
      version: version,
      onCreate: _onCreatingDatabase,
    );

    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
      "CREATE TABLE account(id INTEGER PRIMARY KEY, name TEXT, email TEXT, password TEXT, photoName TEXT)",
    );
  }
}
