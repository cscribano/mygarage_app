import 'rest_helper.dart';
import '../exceptions.dart';

import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository{
  final RestData api = RestData();
  final storage = new FlutterSecureStorage();

  Future<String> authenticate(String username, String password) async {
    return await api.getToken(username, password);
  }

  Future<void> deleteToken() async{
    await storage.delete(key: 'token').timeout(const Duration(seconds: 5));
    return;
  }

  Future<void> persistToken(String token) async{
    await storage.write(key: 'token', value: token).timeout(const Duration(seconds: 5));
    return;
  }

  Future<String> getToken() async {
    var token =  await storage.read(key: 'token').timeout(const Duration(seconds: 5));
    if(token == null)
      throw UnauthenticatedException();
    //test for a 401 response
    return token; //suspect
  }

  Future<Map<String,String>> getHeader() async {
    var token =  await storage.read(key: 'token').timeout(const Duration(seconds: 5));
    if(token == null)
      throw UnauthenticatedException();

    //test authentication
    try{
      await api.getMaxRev(auth_headers: {"Authorization" : "Token "+token});
    }
    on HttpException catch(e) {
      if(e.httpCode == 401){
          await this.deleteToken();
          throw UnauthenticatedException();
      }
    }
    return {"Authorization" : "Token "+token};
  }

}
