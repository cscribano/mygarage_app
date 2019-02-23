import '../../models/vehiclemodel.dart';
import '../base_providers.dart';

import 'dart:async';

class VehicleProvider extends GenericProvider<Vehicle>{

  VehicleProvider._() : super(model: "Vehicle", fromJson: (Map<String, dynamic> jsonData) => Vehicle.fromJson(jsonData));
  static final VehicleProvider _vp = VehicleProvider._(); //singleton
  factory VehicleProvider() => _vp;

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