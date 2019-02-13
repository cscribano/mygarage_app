import '../models/vehiclemodel.dart';
import '../utils/network_util.dart';
import '../models/basemodel.dart';

import 'dart:async';

class RestData{

  //TODO: logout locale se si riceve 'Unauthorized'
  static const String base_url = "http://10.0.2.2:8000/";

  Map<String, String> urls = {
    'get_token' : base_url+'api-token-auth/',
    'get_model' : base_url+'api/',
    'get_updated' : base_url+'api/updated/',
  };

  RestData._(); //private constructor
  static final RestData _RestData = RestData._(); //singleton
  factory RestData() => _RestData;

  NetworkUtil _netutil = NetworkUtil();

  /*-- GET --*/
  Future<String> getToken(String username, String password) async {
    final auth_headers = {'username': username, 'password': password};
    var response = await _netutil.post(urls['get_token'], body: auth_headers);
    return response['token'];
  }

  getMaxRev({Map<String,String> auth_headers}) async{
    var response = await _netutil.get(urls['get_updated'], headers: auth_headers);
    return response['rev_sync__max']?? 0; //danger?
  }

  /*-- PUT -- */
  upsert(Map<String,String> auth_headers, Vehicle newVehicle, int revision) async{
    var post = newVehicle.toJson_API(rev: revision?? 1);
    return await _netutil.post(urls['get_model'], headers: auth_headers, body: post);
  }

  Future<List<Vehicle>>getVehicles(Map<String,String> auth_headers) async {
    var response = await _netutil.get(urls['get_model'], headers: auth_headers);
    List<Vehicle> list = response.isNotEmpty ? response.map<Vehicle>((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Vehicle>>getUpdatedVehicles({Map<String,String> auth_headers, int rev}) async {
    var response = await _netutil.get(urls['get_updated']+rev.toString(), headers: auth_headers);
    List<Vehicle> list = response.isNotEmpty ? response.map<Vehicle>((c) => Vehicle.fromJson(c)).toList() : [];
    return list;
  }
}

abstract class RestProvider<T extends baseModel>{

}