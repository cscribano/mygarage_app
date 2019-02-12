import 'rest_data.dart';

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
      throw("Unauthenticated");
    //test for a 401 response
    return token; //suspect
  }

  getHeader() async {
    var token =  await storage.read(key: 'token').timeout(const Duration(seconds: 5));
    if(token == null)
      throw ("Unauthenticated");

    //test authentication
    try{
      api.getMaxRev(auth_headers: {"Authorization" : "Token "+token});
    }
    catch(error) {
      //if unauthorized
      if (error == "Error while fetching data: 400"){
        this.deleteToken();
      throw ("Unauthenticated");
      }
    }
    return {"Authorization" : "Token "+token};
  }

}
