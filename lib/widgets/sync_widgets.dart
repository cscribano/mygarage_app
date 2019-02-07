import '../data/sync.dart';

import 'package:flutter/material.dart';


class SyncButton extends StatelessWidget implements SyncDelegate{

  BuildContext _cxt;
  Synchronizer syncronizer;

  SyncButton(){
    syncronizer = Synchronizer(delegate: this);
  }

  @override
  void onError(){
    Navigator.pop(_cxt);
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text("An unknown error occourred"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void onUnAuth(){
    Navigator.pop(_cxt);
    showDialog(
        context: _cxt,
        builder: (_cxt) {
          return AlertDialog(
            title: Text("Synchronization"),
            content: Text("To synchronize your data you need to log to your user account"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(_cxt).pop(),
              ),
              FlatButton(
                child: Text("Login"),
                onPressed: () => Navigator.of(_cxt).pushReplacementNamed("/Login"),
              ),
            ],
          );
        });
  }

  @override
  void onSuccess(){
    Navigator.pop(_cxt);
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text("All data synchronized!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _cxt = context;
    return IconButton(
      icon: Icon(Icons.sync, color: Colors.white,),
      tooltip: "Syncronize",
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(child: CircularProgressIndicator(),);
            });
        //await Future.delayed(const Duration(seconds: 5));
        var res = await syncronizer.syncAll();
        //Navigator.pop(context);
      },
    );
  }
}
