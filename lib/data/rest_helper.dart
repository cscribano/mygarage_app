import '../utils/network_util.dart';
import 'dart:async';

/*Provides API endpoints (urls) and perform generic requests*/
class RestData{

  //TODO: logout locale se si riceve 'Unauthorized'
  static const String base_url = "http://10.0.2.2:8000/";
  //static const String base_url = "http://192.168.18.216:8000/";
  //static const String base_url = "http://155.185.121.179:8000/";

  Map<String, String> urls = {
    'get_token' : base_url+'api-token-auth/',
    'get_maxrev' : base_url+'api/updated/',
    'get_vehicles' : base_url+'api/vehicles/',
    'get_updated_vehicles' : base_url+'api/updated_vehicles/',
    'get_expenses' : base_url+'api/expenses/',
    'get_updated_expenses' : base_url+'api/updated_expenses/',
  };

  RestData._(); //private constructor
  static final RestData _restData = RestData._(); //singleton
  factory RestData() => _restData;

  NetworkUtil _netutil = NetworkUtil();

  /*-- GET --*/
  /*Perform login to remote server, returns authentication token*/
  Future<String> getToken(String username, String password) async {
    final auth_headers = {'username': username, 'password': password};
    var response = await _netutil.post(urls['get_token'], body: auth_headers);
    return response['token'];
  }

  /*Calls the max__rev endpoint*/
  getMaxRev({Map<String,String> auth_headers}) async{
    var response = await _netutil.get(urls['get_maxrev'], headers: auth_headers);
    return response['rev_sync__max']?? 0; //danger?
  }
}