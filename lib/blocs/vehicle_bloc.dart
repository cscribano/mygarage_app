import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/db_providers/vehicle_provider.dart';

import 'dart:async';
import 'dart:math';

enum BlocFunction{LIST, INSERT_EXPENSE}

class VehicleBloc implements BlocBase{

  StreamController<List<Vehicle>> _vehicleController = StreamController<List<Vehicle>>.broadcast();
  Sink<List<Vehicle>> get _inVehicle => _vehicleController.sink;
  Stream<List<Vehicle>> get outVehicle => _vehicleController.stream;

  final VehicleProvider _db = VehicleProvider();
  final String tag;
  final BlocFunction function;
  //BlocFunction get function => _function;

  VehicleBloc({this.function : BlocFunction.LIST, this.tag}){
    print("Constructor $tag + ${function.toString()}");
    getVehicles();
  }

  void getVehicles() async{
    print("GetVehicles $tag");
    var vehicles = await _db.getAllVehicles();
    _inVehicle.add(vehicles);
  }

  void addVehicle(Vehicle newVehicle) async {
    await _db.upsert(newVehicle);
    getVehicles();
  }

  void deleteVehicle(String guid) async{
    await _db.markAsDeleted(guid);
    getVehicles();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //await _vehicleController.stream.drain();
    _vehicleController.close();
  }

}