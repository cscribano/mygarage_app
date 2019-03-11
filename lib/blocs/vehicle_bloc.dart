import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/db_providers/vehicle_provider.dart';

import 'dart:async';
import 'dart:math';

enum InsertState{SUCCESS, FAIL}
enum BlocFunction{LIST, INSERT_EXPENSE}

class VehicleBloc implements BlocBase{

  StreamController<List<Vehicle>> _vehicleController = StreamController<List<Vehicle>>.broadcast();
  Sink<List<Vehicle>> get _inVehicle => _vehicleController.sink;
  Stream<List<Vehicle>> get outVehicle => _vehicleController.stream;

  StreamController<InsertState> _insertController = StreamController<InsertState>.broadcast();
  Sink<InsertState> get _inInsert => _insertController.sink;
  Stream<InsertState> get outInsert => _insertController.stream;

  final VehicleProvider _db = VehicleProvider();
  BlocFunction _function = BlocFunction.LIST;
  BlocFunction get function => _function;

  VehicleBloc({BlocFunction function}){
    getVehicles();
    if(function != null){
      _function = function;
    }
  }

  void getVehicles() async{
    _inVehicle.add(await _db.getAllVehicles());
  }

  void addVehicle(Vehicle newVehicle) async {
    await _db.upsert(newVehicle)
      .then((_) => _inInsert.add(InsertState.SUCCESS))
      .catchError((_) => _inInsert.add(InsertState.FAIL));
    getVehicles();
  }

  void deleteVehicle(String guid) async{
    await _db.markAsDeleted(guid);
    getVehicles();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _vehicleController.close();
  }

}