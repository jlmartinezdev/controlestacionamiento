// Import the plugins Path provider and SQLite.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

// Import UserModel
import '/app/models/User.dart';

class DatabaseHelper {
  // SQLite database instance
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // Database name and version
  static const String databaseName = 'ctrol_estacionamiento.db';

  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  static const int versionNumber = 1;

  // Table name
  static const String tableNotes = 'Notes';

  // Table (Users) Columns
  static const String colId = 'id_usuario';
  static const String colTitle = 'title';
  static const String colDescription = 'description';

  // Define a getter to access the database asynchronously.
  Future<Database> get database async {
    // If the database instance is already initialized, return it.
    if (_database != null) {
      return _database!;
    }

    // If the database instance is not initialized, call the initialization method.
    _database = await _initDatabase();

    // Return the initialized database instance.
    return _database!;
  }

  _initDatabase() async {
    //io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    String path = join(await getDatabasesPath(), databaseName);
    // When the database is first created, create a table to store Notes.
    var db =
    await openDatabase(path, version: versionNumber, onCreate: _onCreate);
    return db;
  }

  // Run the CREATE TABLE statement on the database.
  _onCreate(Database db, int intVersion) async {
    await db.execute(
      'CREATE TABLE user(id_usuario INTEGER PRIMARY KEY, name TEXT, dni TEXT, password TEXT, email TEXT)',
    );
    db.execute('CREATE TABLE categoria( id INTEGER PRIMARY KEY, name TEXT, precio REAL)');
    db.execute('CREATE TABLE entrada(id INTEGER PRIMARY KEY, fechahora TEXT, id_usuario INTEGER, monto REAL)');


  }
  // A method that retrieves all the notes from the Notes table.
  Future<List<User>> getAllUsers() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db.query('user', orderBy: '$colId ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => User.fromJson(json)).toList();
  }
  Future<List<User>> users() async {

    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query('user');

    return [
      for (final {
      'id_usuario': id_usuario as int,
      'name': name as String,
      'dni': dni as String,
      'password': password as String,
      'email': email as String
      } in userMaps)
        User(id_usuario: id_usuario, name: name, dni: dni, password: password, email: email),
    ];


  }
  // Serach note by Id
  Future<User> read(int id) async {
    final db = await database;
    final maps = await db.query(
      'user',
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // Define a function that inserts notes into the database
  Future<void> insertMetodo2(User note) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert('user', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  Future<void> updateUser(User user) async {

    final db = await database;
    await db.update(
      'user',
      user.toMap(),
      where: 'id_usuario = ?',
      whereArgs: [user.id_usuario],
    );
  }

  // Define a function to delete a note
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'user',
      where: 'id_usuario = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}