import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/db_providers/vehicle_provider.dart';

import 'dart:async';
import 'dart:math';

class VehicleBloc implements BlocBase{

  StreamController<List<Vehicle>> _vehicleController = StreamController<List<Vehicle>>.broadcast();
  Sink<List<Vehicle>> get _inVehicle => _vehicleController.sink;
  Stream<List<Vehicle>> get outVehicle => _vehicleController.stream;

  final VehicleProvider _db = VehicleProvider();
  //final RestData _api = RestData();

  VehicleBloc(){
    getVehicles();
  }

  void getVehicles() async{
    _inVehicle.add(await _db.getAllVehicles());
  }

  void addVehicle(Vehicle newVehicle){
    _db.upsert(newVehicle);
    print("INSERITO");
    getVehicles();
  }

  void deleteVehicle(String guid) async{
    await _db.markAsDeleted(guid);
    getVehicles();
  }

  void addRandom() async{
    //_db.insertRandom();
    //Vehicle newVehicle = Vehicle.create(testText: "Hello"+"Helloworld"+Random().nextInt(1000).toString(), testNum: Random().nextInt(10000));
    //await _db.upsert(newVehicle);
    getVehicles();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _vehicleController.close();
  }

}