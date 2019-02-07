import '../data/database_helper.dart';
import '../data/rest_data.dart';
import '../data/auth_repository.dart';
import '../models/mockupmodel.dart';

import 'dart:async';

abstract class SyncDelegate{
  void onError();
  void onUnAuth();
  void onSuccess();
}

class Synchronizer {

  final DBProvider _db = DBProvider();
  final RestData _api = RestData();
  final UserRepository _auth = UserRepository();
  final SyncDelegate delegate;

  Synchronizer({this.delegate});

  void syncAll() async {

    List<Mock> updated = await _db.getAllUpdated();
    Map<String, String> headers;

    try {
      headers = await _auth.getHeader();
    }
    catch(error){
      if(error.toString() == "No token")
        delegate.onUnAuth();
      else
        delegate.onError();
      return;
    }

    for(Mock u in updated){
      try{
        var ret = await _api.addMock(headers, u);
        //update tag
        _db.updateSynced(u.id);
      }
      catch (error) {
        print(error);
        delegate.onError();
        return;
      }
    }
    delegate.onSuccess();
  }

}
