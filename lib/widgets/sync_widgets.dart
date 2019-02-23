import '../widgets/bloc_provider.dart';
import '../blocs/vehicle_bloc.dart';
import '../data/sync.dart';
import '../translations.dart';

import 'package:flutter/material.dart';


class SyncButton extends StatelessWidget implements SyncDelegate{

  BuildContext _cxt;
  Synchronizer syncronizer;
  bool _lock = true;

  SyncButton(){
    syncronizer = Synchronizer(delegate: this);
  }

  @override
  void onError(){
    Navigator.canPop(_cxt) ? Navigator.pop(_cxt) : null;
    Scaffold.of(_cxt).removeCurrentSnackBar();
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text(Translations.of(_cxt).text('unknown_error_snack')),
        backgroundColor: Colors.red[800],
      ),
    );
    _lock = false;
  }

  @override
  void onUnAuth(){
    Navigator.canPop(_cxt) ? Navigator.pop(_cxt) : null;
    Scaffold.of(_cxt).removeCurrentSnackBar();
    showDialog(
        context: _cxt,
        builder: (_cxt) {
          return AlertDialog(
            title: Text(Translations.of(_cxt).text('login_to_sync_title')),
            content: Text(Translations.of(_cxt).text('login_to_sync_text')),
            actions: <Widget>[
              FlatButton(
                child: Text(Translations.of(_cxt).text('ok_btn')),
                onPressed: () => Navigator.of(_cxt).pop(),
              ),
              FlatButton(
                child: Text(Translations.of(_cxt).text('login_btn')),
                onPressed: () => Navigator.of(_cxt).pushReplacementNamed("/Login"),
              ),
            ],
          );
        });
    _lock = false;
  }

  @override
  void onSuccess(){
    Navigator.canPop(_cxt) ? Navigator.pop(_cxt) : null;
    Scaffold.of(_cxt).removeCurrentSnackBar();
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text(Translations.of(_cxt).text('sync_ok_snack')),
        backgroundColor: Colors.green[800],
      ),
    );
    _lock = false;
  }

  @override
  Widget build(BuildContext context) {

    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);
    _cxt = context;

    return IconButton(
      icon: Icon(Icons.sync, color: Colors.white,),
      tooltip: Translations.of(_cxt).text('sync_btn_tootlip'),
      onPressed: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(child: CircularProgressIndicator(),);
            });
        if(_lock) {
          var res = await syncronizer.syncAll();
          _lock = true;
        }
        //Navigator.pop(context);
        vehicleBloc.getVehicles();
      },
    );
  }
}
