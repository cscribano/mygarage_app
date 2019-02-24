import '../data/rest_helper.dart';
import '../data/db_providers/vehicle_provider.dart';
import '../data/rest_providers/vehicle_rest_provider.dart';
import '../data/auth_provider.dart';
import '../models/basemodel.dart';
import '../exceptions.dart';
import '../data/base_providers.dart';

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
    on Exception catch(error){
      delegate.onError();
      return;
    }

    //sync vehicles
    //this shit calls constructor multiple times -> crash
    try {
      var ret = await ModelSynchronizer(delegate: delegate,
          headers: headers,
          provider: VehicleProvider(),
          rest_provider: VehicleRestProvider()).syncAll();
    }
    on Exception catch(error){
      print(error);
      delegate.onError();
      return;
    }
    /*
      .then((value) => delegate.onSuccess())
      .catchError((error) => delegate.onError());
    */
    delegate.onSuccess();

  }
}

class ModelSynchronizer<T extends SyncBaseProvider, R extends SyncRestBaseProvider> {

  T _db;
  R _rest;

  final RestData _api = RestData();
  final Map<String, String> headers;
  final SyncDelegate delegate;

  ModelSynchronizer({@required this.delegate, @required this.headers, @required T provider, @required R rest_provider}){
    print("--- ENTERING CONSTRUCTOR ----");
    this._db = provider;
    this._rest = rest_provider;
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
      currentRev = await getRev(); //current client Rev
      print("Client rev: $currentRev");
    }
    on Exception catch(error){
      print(error);
      delegate.onError();
      return;
    }

    //pull...
    //get elements with rev > current rev (NOT >=)
    List<BaseModel> serverUpdated;
    try {
      serverUpdated = await _rest.getUpdatedItems(auth_headers: headers, revision: currentRev);
      print("Tryng to pull ${serverUpdated.length} elements");
    }
    on Exception catch(error){
      print(error);
      delegate.onError();
      return;
    }

    //try insert or update....
    for(BaseModel u in serverUpdated){
      try{
        _db.upsert(u, is_dirty: 0);
      }
      on Exception catch(error){
        print(error);
        delegate.onError();
        return;
      }
    }

    //push...
    //push all dirty elements to server setting sync_rev = serverRev+1
    List<BaseModel> clientUpdated = await _db.getAllDirty(); //get all is_dirty = 1 (true)
    print("Tryng to PUSH ${clientUpdated.length} elements");
    serverRev += 1;

    for(BaseModel u in clientUpdated) {
      try {
        var ret = await _rest.upsert(headers, u, serverRev); //push (create or update)
        //update tag
        _db.updateDirtyFlag(u); //set is_dirty = 0 (false)
      }
      on Exception catch(error){
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
    on Exception catch(error){
      print(error);
      delegate.onError();
      return;
    }
    //delegate.onSuccess();
  }
}