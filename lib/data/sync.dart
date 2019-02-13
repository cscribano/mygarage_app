import '../data/database_helper.dart';
import '../data/rest_data.dart';
import '../data/auth_repository.dart';
import '../models/vehiclemodel.dart';
import '../exceptions.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


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

  Future<int> getRev() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int rev = (prefs.getInt('revision') ?? 0); //current rev starts from 0
    print("current revision: $rev");
    return rev;
  }

  Future<bool> setRev(int rev) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool b = await prefs.setInt('revision', rev);
    return b;
  }

  void syncAll() async {

    Map<String, String> headers;

    //Try to get authentication header (user token)
    try {
      //get authentication token
      headers = await _auth.getHeader();
      print("Auth headers: $headers");
    }
    on UnauthenticatedException{
      delegate.onUnAuth();
      return;
    }
    catch(error){
      delegate.onError();
      return;
    }

    int serverRev;
    int currentRev;

    try{
      serverRev = await _api.getMaxRev(auth_headers: headers); //max(rev) server side
      print("Server rev: $serverRev");
      currentRev = await getRev();
      print("Client rev: $currentRev");
    }
    catch(error){
      print(error);
      delegate.onError();
      return;
    }

    //pull...
    //get elements with rev > current rev (NOT >=)
    List<Vehicle> serverUpdated;
    try {
      serverUpdated = await _api.getUpdatedVehicles(auth_headers: headers, rev: currentRev);
      print("Tryng to pull ${serverUpdated.length} elements");
    }
    catch(error){
      print(error);
      delegate.onError();
      return;
    }

    //try insert or update....
    for(Vehicle u in serverUpdated){
      try{
        //TODO: single Update or Create query
        var exists = await _db.getVehicle(u.guid);
        if(exists != Null){ //this shit doesn't work!
          //update
          print("update");
          _db.updateVehicle(u);
        }
        else{
          print("insert");
          var ret = _db.insertVehicle(u, is_dirty: 0); //todo: check for correct insert
        }
      }
      catch(error){
        print(error);
        delegate.onError();
        return;
      }
    }

    //push...
    //push all dirty elements to server setting sync_rev = serverRev+1
    List<Vehicle> clientUpdated = await _db.getAllDirty(); //get all is_dirty = 1 (true)
    print("Tryng to PUSH ${clientUpdated.length} elements");
    serverRev += 1;

    for(Vehicle u in clientUpdated) {
      try {
        var ret = await _api.addVehicle(headers, u, serverRev); //push (create or update)
        //update tag
        _db.updateDirtyFlag(u.guid); //set is_dirty = 0 (false)
      }
      catch (error) {
        print(error);
        delegate.onError();
        return;
      }
    }

    //we shall increase currentRev only if we have pushed
    //get serverRev back from server and set curREv = serverrev=
    try {
      var newServerRev = await _api.getMaxRev(auth_headers: headers); //max(rev) server side
      print("Updating client rev to: $newServerRev");
      setRev(newServerRev);
    }
    catch(error){
      print(error);
      delegate.onError();
      return;
    }

    delegate.onSuccess();
  }

}

/*
* Test:
* - Inserimento locale -> rest
* -  Inserimento rest -> locale
  - aggiornamento locale (dirty) -> rest
  - aggiornamento rest (rev > rev) -> mobile
*/