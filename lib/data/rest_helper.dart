import '../utils/network_util.dart';
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
  static final RestData _restData = RestData._(); //singleton
  factory RestData() => _restData;

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
}