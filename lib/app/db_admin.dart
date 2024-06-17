import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/User.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'estacionamiento_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
       db.execute(
        'CREATE TABLE user(id_usuario INTEGER PRIMARY KEY, name TEXT, dni TEXT, password TEXT, email TEXT)',
      );
       db.execute('CREATE TABLE categoria( id INTEGER PRIMARY KEY, name TEXT, precio REAL)');
       db.execute('CREATE TABLE entrada(id INTEGER PRIMARY KEY, fechahora TEXT, id_usuario INTEGER, monto REAL)');

      return;


    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  // Define a function that inserts dogs into the database
  Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await database;


    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<User>> users() async {

    final db = await database;

    final List<Map<String, Object?>> userMaps = await db.query('users');

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

  Future<void> updateUser(User user) async {

    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id_usuario = ?',
      whereArgs: [user.id_usuario],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id_usuario = ?',
      whereArgs: [id],
    );
  }

  var admin = User(
    id_usuario: 0,
    name: 'Admin',
    dni: '35',
    password: '12345',
    email: 'admin@admin'
  );

  await insertUser(admin);

  print(await users());


  admin = User(
    id_usuario: admin.id_usuario,
    name: admin.name,
    dni: admin.dni,
    password: admin.password,
    email: admin.email
  );
  await updateUser(admin);

  print(await users());

  //await deleteUser(admin.id_usuario);

  print(await users());
}



