import 'package:mygarage/data/database_helper.dart';
import '../models/basemodel.dart';

abstract class SyncBaseProvider<T extends BaseModel>{
  Future<int> upsert(T item, {int is_dirty});
  Future<List<T>> getAllDirty();
  Future<bool> updateDirtyFlag(T guid);
}

abstract class SyncRestBaseProvider<T extends BaseModel>{
  Future<dynamic> upsert(Map<String,String> auth_headers, T newItem, int revision);
  Future<List<T>>getUpdatedItems({Map<String,String> auth_headers, int revision});
}


/*This class provides a generic implementation of the SyncBaseProvider interface
* String model: table name in the SQLIte database
*  T Function(Map<String, dynamic> json) fromJson esempio: super(model: "Vehicle", fromJson: (Map<String, dynamic> jsonData) => Vehicle.fromJson(jsonData));*/

class GenericProvider<T extends BaseModel> implements SyncBaseProvider<T>{

  static DBProvider _db = DBProvider();
  final database = _db.database;

  String model;
  T Function(Map<String, dynamic> json) fromJson;

  GenericProvider({this.model, this.fromJson});

  @override
  Future<List<T>> getAllDirty() async{
    final db = await database; //call getter
    var res = await db.query(model, where: "is_dirty = ? OR is_deleted = ?", whereArgs: [1, 1]);
    List<T> list = res.isNotEmpty ? res.map((c) =>this.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<bool> updateDirtyFlag(T item) async {
    final db = await database; //call getter
    var res = await db.update(model, {"is_dirty":0}, where: "guid = ?", whereArgs: [item.guid]);
    return res==1; //bool?
  }

  @override
  Future<int> upsert(T item, {int is_dirty}) async {
    final db = await database; //call getter
    int ret;
    //todo: test also foreign key "vehicle"?
    var res = await db.query(model, where: "guid = ?", whereArgs: [item.guid]);
    if(res.isNotEmpty){
      //update
      ret = await db.update(model, item.toJson(dirty: is_dirty?? 1), where: "guid = ?", whereArgs: [item.guid]);
    }
    else{
      //create
      ret = await db.insert(model, item.toJson(dirty: is_dirty?? 1));
    }
    return ret;
  }

}