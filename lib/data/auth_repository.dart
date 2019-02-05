import 'rest_data.dart';

import 'dart:async';

class UserRepository{
  final RestData api = RestData();
  static bool _auth = false;

  Future<String> authenticate(String username, String password) async {
    //return await api.getToken(username, password);
    await Future.delayed(Duration(seconds: 1));
    _auth = true;
    return("Hellowrodl!!!");
  }

  Future<void> deleteToken() async{
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> persistToken() async{
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 1));
    return _auth;
  }

}
