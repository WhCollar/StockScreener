import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:coffee/database/models/ticker.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await initDB();

  initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'stock_screener.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Ticker (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            title TEXT UNIQUE NOT NULL,
            favorite BIT DEFAULT 0
          )
        ''');
      },
      version: 1
    );
  }

  newTicker(Ticker newTicker) async {
    final db = await database;
    var raw = await db.execute("INSERT INTO Ticker (title) "
        "SELECT '${newTicker.title}'"
        "WHERE NOT EXISTS(SELECT 1 FROM Ticker WHERE title = '${newTicker.title}');");
    return raw;
  }

  getTicker(int id) async {
    final db = await database;
    var res =await  db.query("Ticker", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Ticker.fromMap(res.first) : Null ;
  }

  Future<List<Ticker>> getAllTicker() async {
    final db = await database;
    var res = await db.query("Ticker");
    List<Ticker> list;
    if (res.isNotEmpty) {
      list = res.map((c) => Ticker.fromMap(c)).toList();
    } else {
      list = [];
    }
    return list;
  }

  Future<List<Ticker>> getFavoriteTicker() async {
    final db = await database;
    var res = await db.rawQuery(''' 
      SELECT * FROM Ticker WHERE favorite=1
    ''');
    List<Ticker> list;
    if (res.isNotEmpty) {
      list = res.toList().map((e) => Ticker.fromMap(e)).toList();
    } else {
      list = [];
    }
    return list;
  }

  addOrRemoveFromFavorites(Ticker ticker) async {
    final db = await database;
    Ticker favorite = Ticker(
        id: ticker.id,
        title: ticker.title,
        favorite: !ticker.favorite!);
    var res = await db.update("Ticker", favorite.toMap(),
    where: "id = ?", whereArgs: [ticker.id]);
    return res;
  }

}
