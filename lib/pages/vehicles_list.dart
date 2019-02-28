import '../widgets/vehicle_tile.dart';
import 'package:mygarage/blocs/auth_bloc.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../translations.dart';

import '../widgets/sync_widgets.dart';
import '../widgets/default_drawer.dart';

import 'package:flutter/material.dart';

class VehiclesList extends StatefulWidget {

  VehiclesList({Key key}) : super(key: key);

  @override
  _VehiclesListState createState() => _VehiclesListState();
}

class _VehiclesListState extends State<VehiclesList>{

  @override
  Widget build(BuildContext context) {

    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);
    final scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
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
          onPressed: vehicleBloc.addRandom,
      ),
      drawer: BlocProvider(bloc: AuthBloc(), child: DefaultDrawer(highlitedVoice: 2,),),
    );
  }

}