import '../data/database_helper.dart';
import '../data/rest_data.dart';
import '../data/auth_repository.dart';
import '../models/mockupmodel.dart';

import 'dart:async';

class Syncronizer {

  final DBProvider _db = DBProvider();
  final RestData _api = RestData();
  final UserRepository _auth = UserRepository();

  void syncAll() async {

    List<Mock> updated = await _db.getAllUpdated();
    Map<String,String> headers = await _auth.getHeader();

    for(Mock u in updated){
      try{
        var ret = await _api.addMock(headers, u);
        //update tag
        _db.updateSynced(u.id);
      }
      catch (error) {
        print(error);
      }
    }
  }

}
