import '../models/mockupmodel.dart';
import '../models/user.dart';
import '../utils/network_util.dart';

import 'dart:async';

class RestData{

  static const String base_url = "http://10.0.2.2:8000/";

  Map<String, String> urls = {
    'get_token' : base_url+'api-token-auth/',
    'get_model' : base_url+'api/',
  };

  RestData._(); //private constructor
  static final RestData _RestData = RestData._(); //singleton
  factory RestData() => _RestData;

  NetworkUtil _netutil = NetworkUtil();

  Future<User> getToken(String username, String password) async {
    final auth_headers = {'username': username, 'password': password};
    var response = await _netutil.post(urls['get_token'], body: auth_headers);
    response['username'] = username;
    return User.fromJson(response);
  }

  Future<List<Mock>>getMocks(Map<String,String> auth_headers) async {
    var response = await _netutil.get(urls['get_model'], headers: auth_headers);
    List<Mock> list = response.isNotEmpty ? response.map<Mock>((c) => Mock.fromJson(c)).toList() : [];
    return list;
  }

  Future<Mock> getMock(Map<String,String> auth_headers, int id)async{
    var response = await _netutil.get(urls['get_model']+id.toString(), headers: auth_headers);
    return Mock.fromJson(response);
  }

}