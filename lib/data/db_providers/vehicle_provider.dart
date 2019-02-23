import '../database_helper.dart';
import '../../models/vehiclemodel.dart';
import '../base_providers.dart';

import 'dart:async';

class VehicleProvider implements SyncBaseProvider<Vehicle>{

  static DBProvider _db = DBProvider();
  final database = _db.database;

  VehicleProvider._();
  static final VehicleProvider _vp = VehicleProvider._(); //singleton
  factory VehicleProvider() => _vp;

  /*-- Interface methods --*/
  @override
  Future<int> upsert(Vehicle item, {int is_dirty}) async{
    final db = await database; //call getter
    int ret;
    var res = await db.query("Vehicle", where: "guid = ?", whereArgs: [item.guid]);
    if(res.isNotEmpty){
      //update
      ret = await db.update("Vehicle", item.toJson(dirty: is_dirty?? 1), where: "guid = ?", whereArgs: [item.guid]);
    }
    else{
      //create
      ret = await db.insert("Vehicle", item.toJson(dirty: is_dirty?? 1));
    }
    return ret;
  }

  @override
  Future<List<Vehicle>> getAllDirty() async {
    final db = await database; //call getter
    var res = await db.query("Vehicle", where: "is_dirty = ? OR is_deleted = ?", whereArgs: [1, 1]);
    List<Vehicle> list = res.isNotEmpty ? res.map((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<bool> updateDirtyFlag(Vehicle item) async{
    final db = await database; //call getter
    var res = await db.update("Vehicle", {"is_dirty":0}, where: "guid = ?", whereArgs: [item.guid]);
    return res==1; //bool?
  }

/*-- Additional methods --*/

  //read Vehicle(id)
  getVehicle(String guid) async {
    final db = await database; //call getter
    var res = await db.query("Vehicle", where: "guid = ?", whereArgs: [guid]);
    return res.isNotEmpty ? Vehicle.fromJson(res.first) : Null; //this is not ok!
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final db = await database;
    var res = await db.query("Vehicle",  where: "is_deleted = ?", whereArgs: [0]).timeout(const Duration(seconds: 2));
    List<Vehicle> list = res.isNotEmpty ? res.map((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }

  markAsDeleted(String guid) async{
    final db = await database;
    var ret = await db.update("Vehicle", {'is_deleted': '1'}, where: 'guid = ?', whereArgs: [guid]);
    return ret;
  }
}