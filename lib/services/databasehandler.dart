import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqlitedemo/user.dart';

class DatabaseHandler {

  //initialization
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'example.db'), //example.db is the name of the database
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,age INTEGER NOT NULL, country TEXT NOT NULL, email TEXT)",
        );
      },
      version: 1,
    );
  }

  //Add single user
  Future<int> insertUser(User user) async {
    int result = 0;
    final Database db = await initializeDB();
      result = await db.insert('users', user.toMap());
    return result;
  }

  //Add multiple users
  Future<int> insertUsers(List<User> users) async {
    int result = 0;
    final Database db = await initializeDB();
    for(var user in users){
      result = await db.insert('users', user.toMap());
    }
    return result;
  }

  //Get users
  Future<List<User>> retrieveUsers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('users');
    return queryResult.map((e) => User.fromMap(e)).toList();
  }

  //function to update a user
  Future<void> updateUser(User user) async {
    final db = await initializeDB();
    await db.update(
      'users',
      user.toMap(),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  //Delete users
  Future<void> deleteUser(int id) async {
    final db = await initializeDB();
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
  
}