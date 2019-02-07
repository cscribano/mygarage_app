import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil{

  NetworkUtil._(); //private constructor
  static final NetworkUtil NetUtil = NetworkUtil._(); //singleton
  factory NetworkUtil() => NetUtil;

  Future<dynamic> get(String url, {Map headers}) async {
    http.Response response;
    response = await http.get(url, headers: headers).timeout(const Duration(seconds: 2));

    final String ret = response.body;
    final int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 400){
      throw Exception("Error while fetching data: "+statusCode.toString());
    }
    return jsonDecode(ret);
  }

  Future<dynamic> post(String url, {Map headers, body, encoding}) async{

    http.Response response;
    response = await http.post(url, body: body, headers: headers, encoding: encoding).timeout(const Duration(seconds: 2));

    final String ret = response.body;
    final int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 400){
      throw Exception("Error while fetching data: "+statusCode.toString()); //FIX: 20x == not error
    }
    return jsonDecode(ret);
  }
}