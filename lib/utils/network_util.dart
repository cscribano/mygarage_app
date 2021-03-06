import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../exceptions.dart';

class NetworkUtil{

  NetworkUtil._(); //private constructor
  static final NetworkUtil NetUtil = NetworkUtil._(); //singleton
  factory NetworkUtil() => NetUtil;

  Future<dynamic> get(String url, {Map headers}) async {
    http.Response response;
    response = await http.get(url, headers: headers).timeout(const Duration(seconds: 5));

    final String ret = response.body;
    final int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 400){
      //throw Exception("Error while fetching data: "+statusCode.toString());
      throw HttpException(httpCode: statusCode);
    }
    return jsonDecode(ret);
  }

  Future<dynamic> post(String url, {Map headers, Map body, encoding}) async{
    body.removeWhere((k,v) => (v == null));
    http.Response response;
    response = await http.post(url, body: body, headers: headers, encoding: encoding).timeout(const Duration(seconds: 5));

    final String ret = response.body;
    final int statusCode = response.statusCode;

    if(statusCode < 200 || statusCode >= 400){
      //throw Exception("Error while fetching data: "+statusCode.toString()); //FIX: 20x == not error
      throw HttpException(httpCode: statusCode, error: response.body.toString());
    }
    return jsonDecode(ret);
  }
}