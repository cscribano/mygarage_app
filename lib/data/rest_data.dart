import '../models/mockupmodel.dart';
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
  static final RestData _RestData = RestData._(); //singleton
  factory RestData() => _RestData;

  NetworkUtil _netutil = NetworkUtil();

  /*-- GET --*/
  Future<String> getToken(String username, String password) async {
    final auth_headers = {'username': username, 'password': password};
    var response = await _netutil.post(urls['get_token'], body: auth_headers);
    return response['token'];
  }

  Future<List<Mock>>getMocks(Map<String,String> auth_headers) async {
    var response = await _netutil.get(urls['get_model'], headers: auth_headers);
    List<Mock> list = response.isNotEmpty ? response.map<Mock>((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<Mock>>getUpdatedMocks({Map<String,String> auth_headers, int rev}) async {
    var response = await _netutil.get(urls['get_updated']+rev.toString(), headers: auth_headers);
    List<Mock> list = response.isNotEmpty ? response.map<Mock>((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  getMaxRev({Map<String,String> auth_headers}) async{
    var response = await _netutil.get(urls['get_updated'], headers: auth_headers);
    return response['rev_sync__max']?? 0; //danger?
  }

  /*-- PUT -- */
  addMock(Map<String,String> auth_headers, Mock newMock, int revision) async{
      var post = newMock.toJson_API(rev: revision?? 1);
      return await _netutil.post(urls['get_model'], headers: auth_headers, body: post);
  }

}