import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/database_helper.dart';
import '../data/rest_data.dart';

import 'dart:async';

class VehicleBloc implements BlocBase{

  StreamController<List<Vehicle>> _VehicleController = StreamController<List<Vehicle>>.broadcast();
  Sink<List<Vehicle>> get _inVehicle => _VehicleController.sink;
  Stream<List<Vehicle>> get outVehicle => _VehicleController.stream;

  final DBProvider _db = DBProvider();
  final RestData _api = RestData();

  VehicleBloc(){
    getVehicles();
  }

  void getVehicles() async{
    _inVehicle.add(await _db.getAllVehicles());
  }

  void addVehicle(Vehicle newVehicle){
    _db.insertVehicle(newVehicle);
    getVehicles();
  }

  void addRandom(){
    _db.insertRandom();
    getVehicles();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _VehicleController.close();
  }

}