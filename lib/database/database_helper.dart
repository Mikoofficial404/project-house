import 'package:path/path.dart';
import 'package:project_house/models/pemilik_model.dart';
import 'package:project_house/models/penghasilan.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'pemilik.db');

    await deleteDatabase(path);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE pemilik(noKtp TEXT PRIMARY KEY, nama TEXT, noHp TEXT, email TEXT)',
        );
        await db.execute(
          'CREATE TABLE penghasilan(id INTEGER PRIMARY KEY AUTOINCREMENT, sumber TEXT, jumlah REAL, tanggal TEXT)',
        );
      },
    );
  }

  Future<int> insertPemilik(PemilikModel pmk) async {
    final db = await database;
    return await db.insert(
      'pemilik',
      pmk.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PemilikModel>> getPemilik() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pemilik');
    return maps.map((data) => PemilikModel.fromMap(data)).toList();
  }

  Future<int> updatePemilik(PemilikModel pmk) async {
    final db = await database;
    return await db.update(
      'pemilik',
      pmk.toMap(),
      where: 'noKtp=?',
      whereArgs: [pmk.noKtp],
    );
  }

  Future<int> deletePemilik(String noKtp) async {
    final db = await database;
    return await db.delete('pemilik', where: 'noKtp=?', whereArgs: [noKtp]);
  }

  Future<int> insertPenghasilan(Penghasilan png) async {
    final db = await database;
    return await db.insert(
      'penghasilan',
      png.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Penghasilan>> getPenghasilan() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('penghasilan');
    return maps.map((data) => Penghasilan.fromMap(data)).toList();
  }

  Future<int> updatePenghasilan(Penghasilan png) async {
    final db = await database;
    return await db.update(
      'penghasilan',
      png.toMap(),
      where: 'id=?',
      whereArgs: [png.id],
    );
  }

  Future<int> deletePenghasilan(int id) async {
    final db = await database;
    return await db.delete('pemilik', where: 'id=?', whereArgs: [id]);
  }
}
