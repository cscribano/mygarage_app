import '../widgets/vehicle_tile.dart';
import 'package:mygarage/blocs/auth_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../translations.dart';

import '../widgets/sync_widgets.dart';
import '../widgets/default_drawer.dart';

import 'insert_vehicle.dart';

import 'package:flutter/material.dart';

class VehiclesList extends StatefulWidget {

  VehiclesList({Key key}) : super(key: key);

  @override
  _VehiclesListState createState() => _VehiclesListState();
}

class _VehiclesListState extends State<VehiclesList>{

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);
    //addPostScaffold("prova", Colors.red);
    vehicleBloc.outInsert.listen((data){
        if(data == InsertState.SUCCESS){
          addPostScaffold("Vehicle succesfully added!", Colors.green[800]);
        }
        else{
          addPostScaffold("Something went wrong inserting the vehicle", Colors.red[800]);
        }
        build(context);//trigger widget rebuild
    },
      onError: (error) => addPostScaffold("An unknown error happened", Colors.red[800]),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text(Translations.of(context).text('home_title')),
        actions: <Widget>[
          SyncButton(),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: vehicleBloc.outVehicle,//bloc.allVehicles,
            builder: (context, AsyncSnapshot<List<Vehicle>> snapshot){
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if (!snapshot.hasData){
                vehicleBloc.getVehicles();
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Vehicle item = snapshot.data[index];
                  return VehicleTile(vehicle: item,);
                },
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () => Navigator.pushNamed(context, '/InsertVehicle'),
      ),
      drawer: BlocProvider(bloc: AuthBloc(), child: DefaultDrawer(highlitedVoice: 2,),),
    );
  }

  void addPostScaffold(String text, Color color){
    WidgetsBinding.instance.addPostFrameCallback((_) => _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text), backgroundColor: color,)));
  }

}