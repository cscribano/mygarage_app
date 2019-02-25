import '../../models/vehiclemodel.dart';
import '../base_providers.dart';
import '../rest_helper.dart';
import '../../utils/network_util.dart';

class VehicleRestProvider implements SyncRestBaseProvider<Vehicle>{

  RestData _api = RestData();
  NetworkUtil _netutil = NetworkUtil();

  VehicleRestProvider._();
  static final VehicleRestProvider _vrp = VehicleRestProvider._(); //singleton
  factory VehicleRestProvider() => _vrp;

  @override
  Future<List<Vehicle>> getUpdatedItems({Map<String, String> auth_headers, int revision}) async{
    var response = await _netutil.get(_api.urls['get_updated_vehicles']+revision.toString(), headers: auth_headers);
    List<Vehicle> list = response.isNotEmpty ? response.map<Vehicle>((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<dynamic> upsert(Map<String, String> auth_headers, Vehicle newItem, int revision) async{
    var post = newItem.toJson_API(rev: revision?? 1);
    return await _netutil.post(_api.urls['get_vehicles'], headers: auth_headers, body: post);
  }

  Future<List<Vehicle>>getVehicles(Map<String,String> auth_headers) async {
    var response = await _netutil.get(_api.urls['get_vehicles'], headers: auth_headers);
    List<Vehicle> list = response.isNotEmpty ? response.map<Vehicle>((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }

  @override
  Future<int> getModelMaxRev({Map<String, String> auth_headers}) async {
    var response = await _netutil.get(_api.urls['get_updated_vehicles'], headers: auth_headers);
    return response['rev_sync__max']?? 0; //danger?
  }
}