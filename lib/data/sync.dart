import '../data/database_helper.dart';
import '../data/rest_helper.dart';
import '../data/db_providers/vehicle_provider.dart';
import '../data/auth_provider.dart';
import '../models/vehiclemodel.dart';
import '../exceptions.dart';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


abstract class SyncDelegate{
  void onError();
  void onUnAuth();
  void onSuccess();
}

class Synchronizer{

  final SyncDelegate delegate;
  final UserRepository _auth = UserRepository();

  Synchronizer({@required this.delegate});

  void syncAll() async {

    //1. Try to get authentication credentials
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

    //sync vehicles
    try {
      var ret = await ModelSynchronizer(delegate: delegate, headers: headers, provider: vehicleProvider()).syncAll();
      //then, onerror......
    }
    catch(error){
      print("Errore (Synchronizer): $error");
      delegate.onError();
      return;
    }
    delegate.onSuccess();
  }
}

class ModelSynchronizer<T extends baseProvider> {

  //final DBProvider _db = DBProvider();
  //final vehicleProvider _db = vehicleProvider();
  T _db;
  final RestData _api = RestData();
  Map<String, String> headers;
  final SyncDelegate delegate;

  ModelSynchronizer({@required this.delegate, @required this.headers, @required provider,}){
    this._db = provider;
  }

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

  Future<void> syncAll() async {

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
        _db.upsert(u, is_dirty: 0);
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
        var ret = await _api.upsert(headers, u, serverRev); //push (create or update)
        //update tag
        _db.updateDirtyFlag(u); //set is_dirty = 0 (false)
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
    //delegate.onSuccess();
  }
}