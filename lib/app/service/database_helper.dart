// Import the plugins Path provider and SQLite.

import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/models/Entrada.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
  static const int versionNumber = 5;

  // Table name
  static const String tableNotes = 'User';

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
    // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
    // this step, it will use the sqlite version available on the system.


    String path = join(await getDatabasesPath(), databaseName);

    var db =
    await openDatabase(path, version: versionNumber, onCreate: _onCreate);
    return db;
  }

  // Run the CREATE TABLE statement on the database.
  _onCreate(Database db, int intVersion) async {
    await db.execute(
      'CREATE TABLE user(id_usuario INTEGER PRIMARY KEY, name TEXT, dni TEXT, password TEXT, email TEXT, rol INTEGER)',
    );
    await db.execute('CREATE TABLE categoria( id INTEGER PRIMARY KEY, name TEXT, precio REAL)');
    await db.execute("CREATE TABLE entrada(id INTEGER PRIMARY KEY, id_usuario INTEGER, monto REAL, fechahora INTEGER DEFAULT (cast(strftime('%s','now') as int))");


  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query('user', orderBy: '$colId ASC');
    return result.map((json) => User.map(json)).toList();
  }
  Future<List<Entrada>> getAllEntrada() async {
    final db = await database;
    final result = await db.query('entrada', orderBy: 'id DESC');
    print(result);
    return result.map((json) => Entrada.map(json)).toList();
  }

  Future<void> getAllEntradaByDate(String desde, String hasta) async {
    final db = await database;
    final result = await db.rawQuery("Select *  from entrada where date(datetime(fechahora, 'unixepoch','localtime')) between '${desde}' and '${hasta}'");
    print(result);

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
      'email': email as String,
      'rol': rol as int
      } in userMaps)
        User(id_usuario: id_usuario, name: name, dni: dni, password: password, email: email, rol: rol),
    ];
  }

  Future<List<Categoria>> getAllCategorias() async {
    final db = await database;
    final result = await db.query('categoria', orderBy: 'id ASC');
    return result.map((json) => Categoria.map(json)).toList();
  }

  Future<User> checkUser(String email, String password) async{
    var dbClient = await database;
    final maps = await dbClient.query("user",where:'"email" = ? and "password"=?',whereArgs: [email, password]);

    if (maps.isNotEmpty) {
     // print(maps.first);
      return User.map(maps.first);
     // return User.fromJson(maps.first);
    } else {
      return Future<User>.error("Correo/Contraseña incorrecta...");
    }

  }
  // Serach note by Id
  Future<User> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      'user',
      where: '$colId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.map(maps.first);
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
  Future<int> getMaxUser() async {
    final db = await database;
    final maps= await db.query('user',orderBy: 'id_usuario DESC');
    if(maps.isNotEmpty){
      return int.parse(maps[0]["id_usuario"].toString());
    }else{
      return 0;
    }

  }
  // Define a function that inserts notes into the database
  Future<void> insertMetodo2(User note) async {
    final db = await database;
    await db.insert('user', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int> getMaxCategoria() async {
    final db = await database;
    final maps= await db.query('categoria',orderBy: 'id DESC');
    if(maps.isNotEmpty){
      return int.parse(maps[0]["id"].toString());
    }else{
      return 0;
    }

  }

  Future<void> insertCategoria(Categoria cat) async {
    final db = await database;
    try {
        await db.insert('categoria', cat.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    }catch(error){
      print(error);
    }
  }
  static int currentTimeInSeconds() {
    var ms = (DateTime.now()).millisecondsSinceEpoch;
    return (ms / 1000).round();
  }
  Future<int> insertEntrada(Entrada ent) async {
      Database db = await database;
      var row = {
        'id_usuario'  : ent.id_usuario,
        'monto' : ent.monto,
        'fechahora': currentTimeInSeconds()
      };
      return await db.insert('entrada', row);  //the id
    }


  Future<void> updateUser(User user) async {

    final db = await database;
    await db.update(
      'user',
      user.toJson(),
      where: 'id_usuario = ?',
      whereArgs: [user.id_usuario],
    );
  }

  Future<void> updateCategoria(Categoria cat) async {

    final db = await database;
    await db.update(
      'categoria',
      cat.toJson(),
      where: 'id = ?',
      whereArgs: [cat.id],
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
  Future<void> deleteCategoria(int id) async {
    final db = await database;
    await db.delete(
      'categoria',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> deleteEntrada(int id) async {
    final db = await database;
    await db.delete(
      'entrada',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> deleteAllCategoria() async {
    final db = await database;
    await db.delete(
      'categoria'
    );
  }


 Future close() async {
    final db = await database;
    db.close();
  }
}