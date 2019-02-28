import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String create_vehicle_table = """CREATE TABLE Vehicle (
    guid TEXT PRIMARY KEY,
    type TEXT,
    brand TEXT,
    model TEXT,
    fuel TEXT,
    current_odo INTEGER,
    buy_price REAL,
    model_year INTEGER,
    is_dirty BIT,
    is_deleted BIT
   )""";

const String create_expense_table = """CREATE TABLE Expense (
    guid TEXT PRIMARY KEY,
    vehicle TEXT,
    expense_class TEXT,
    expense_category TEXT,
    details TEXT,
    date_paid TEXT,
    date_to_pay TEXT,
    cost REAL,
    paid REAL,
    is_dirty BIT,
    is_deleted BIT,
    FOREIGN KEY(vehicle) REFERENCES Vehicle(guid) ON DELETE CASCADE
   )""";

/*Utility class to provide an instance of Database (schema is created if not exists)*/
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
    await db.execute(create_vehicle_table);
    await db.execute(create_expense_table);
  }
}