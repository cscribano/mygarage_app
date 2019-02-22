import '../widgets/bloc_provider.dart';
import '../blocs/vehicle_bloc.dart';
import '../data/sync.dart';
import '../translations.dart';

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
    Scaffold.of(_cxt).removeCurrentSnackBar();
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text(Translations.of(_cxt).text('unknown_error_snack')),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void onUnAuth(){
    Navigator.pop(_cxt);
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
  }

  @override
  void onSuccess(){
    Navigator.pop(_cxt);
    Scaffold.of(_cxt).removeCurrentSnackBar();
    Scaffold.of(_cxt).showSnackBar(
      SnackBar(
        content: Text(Translations.of(_cxt).text('sync_ok_snack')),
        backgroundColor: Colors.green,
      ),
    );
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
        //await Future.delayed(const Duration(seconds: 5));
        var res = await syncronizer.syncAll();
        vehicleBloc.getVehicles();
        //Navigator.pop(context);
      },
    );
  }
}
