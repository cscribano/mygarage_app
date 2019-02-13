import '../models/mockupmodel.dart';

import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String create_test_table= """CREATE TABLE Mock (
    guid TEXT PRIMARY KEY,
    test_text TEXT,
    test_num INTEGER,
    is_dirty BIT,
    is_deleted BIT
   )""";


class DBProvider{
  DBProvider._(); //private constructor
  static final DBProvider _db = DBProvider._(); //singleton
  factory DBProvider() => _db;

  static Database _database;

  Future<Database> get database async{
    if(_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async{
    await db.execute(create_test_table);
  }

/*-- INSERT --*/
  //insert Mock
  insertMock(Mock newMock, {int is_dirty}) async{
    final db = await database; //call getter
    var res = await db.insert("Mock", newMock.toJson(dirty: is_dirty?? 1));
    return res;
  }

  insertRandom() async {
    final db = await database; //call getter
    Mock newMock = Mock.create(testText: "Hello"+"Helloworld"+Random().nextInt(1000).toString(), testNum: Random().nextInt(10000));
    var res = await db.insert("Mock", newMock.toJson(dirty: 1));
    return res;
  }

/*-- REQUEST --*/

  //read Mock(id)
  getMock(String guid) async {
    final db = await database; //call getter
    var res = await db.query("Mock", where: "guid = ?", whereArgs: [guid]);
    return res.isNotEmpty ? Mock.fromJson(res.first) : Null; //this is not ok!
  }

  Future<List<Mock>> getAllMocks() async {
    final db = await database;
    var res = await db.query("Mock").timeout(const Duration(seconds: 2));
    List<Mock> list = res.isNotEmpty ? res.map((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Mock>> getAllDirty() async {
    final db = await database; //call getter
    var res = await db.query("Mock", where: "is_dirty = ?", whereArgs: [1]);
    List<Mock> list = res.isNotEmpty ? res.map((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  /*-- UPDATE -- */
  updateDirtyFlag(String guid) async{
    final db = await database; //call getter
    var res = await db.update("Mock", {"is_dirty":0}, where: "guid = ?", whereArgs: [guid]);
    return res==1; //bool?
  }

  updateMock(Mock updated) async{
    final db = await database; //call getter
    //per il futuro passare dirty = 1 o 0 se è stato aggiornato da locale o da API
    var res = await db.update("Mock", updated.toJson(dirty: 0), where: "guid = ?", whereArgs: [updated.guid]);
    return res;
  }
}