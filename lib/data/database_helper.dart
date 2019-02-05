import '../models/mockupmodel.dart';

import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String create_test_table= """CREATE TABLE Mock (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    owner TEXT,
    test_text TEXT,
    test_num INTEGER,
    is_update BIT,
    is_deleted BIT
   )""";

const String populate_with_garbage = """
insert into Mock(owner,test_text,test_num,is_update,is_deleted) values ("test","Hello",69,1,1);
""";

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
    await db.execute(populate_with_garbage);
    //print(create_test_table);
  }

/*-- INSERT --*/
  //insert Mock
  insertMock(Mock newMock) async{
    final db = await database; //call getter
    var res = await db.insert("Mock", newMock.toJson()); //testare se funnziona con autoincrement
    return res;
  }

  insertRandom() async {
    final db = await database; //call getter
    Mock newMock = Mock(owner: "test", testText: "Helloworld"+Random().nextInt(1000).toString(),testNum: Random().nextInt(10000));
    var res = await db.insert("Mock", newMock.toJson());
    return res;
  }

/*-- REQUEST --*/

  //read Mock(id)
  getMock(int id) async {
    final db = await database; //call getter
    var res = await db.query("Mock", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Mock.fromJson(res.first) : Null;
  }

  Future<List<Mock>> getAllMocks() async {
    final db = await database;
    var res = await db.query("Mock");
    List<Mock> list = res.isNotEmpty ? res.map((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  getAllUpdated() async {
    final db = await database; //call getter
    var res = await db.query("Mock", where: "is_update = ?", whereArgs: [1]);
    return res.isNotEmpty ? Mock.fromJson(res.first) : Null;
  }

  /*-- DELETE -- */

}