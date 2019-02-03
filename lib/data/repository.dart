import 'rest_data.dart';
//import 'database_helper.dart';
//import '../models/mockupmodel.dart';

import 'dart:async';
/*
class Repository{
  final DBProvider db = DBProvider();

  Future<List<Mock>> fetchAllMocks () => db.getAllMocks();
}
*/

class UserRepository{
  final RestData api = RestData();

  Future<String> authenticate(String username, String password) async {
    return await api.getToken(username, password);
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
    return false;
  }

}
