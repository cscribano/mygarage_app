import '../blocs/vehicle_bloc.dart';
import '../models/vehiclemodel.dart';
import '../translations.dart';

import '../widgets/garage_tiles.dart';
import '../widgets/bloc_provider.dart';
import '../widgets/sync_widgets.dart';
import '../widgets/default_drawer.dart';
import '../widgets/empty_placeholder.dart';
import '../widgets/icons.dart';

import 'vehicle_details.dart';
import 'insert_vehicle.dart';

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

    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
          title: Text(Translations.of(context).text('home_title')),
        actions: <Widget>[
          SyncButton(
            thenCallback: () => vehicleBloc.getVehicles(),
          ),
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
                else if(snapshot.hasData && snapshot.data.length == 0){
                  return EmptyPlaceHolder(
                    //Todo: make this expense type aware (e.g different text/icons for different expenses types)
                    image:Image.asset('assets/icons/big/icons8-maintenance-96.png', color: Colors.black45,),
                    fontSize: 20,
                    text: "Ad a New Expense",
                  );
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
          onPressed: () {
          Navigator.of(context).pushNamed('/InsertVehicle');
          }
      ),
      drawer: Navigator.of(context).canPop() ? null : DefaultDrawer(highlitedVoice: 2,),
    );
  }

}


class VehicleTile extends StatelessWidget{

  final Vehicle vehicle;
  VehicleTile({Key key, this.vehicle}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);

    return MyGarageTile(
      text: Text(
        capitalize(vehicle.brand) + " " +capitalize(vehicle.model),
        style: TextStyle(fontWeight: FontWeight.bold,),
        overflow: TextOverflow.ellipsis,
      ),
      subtext: Text(
        "Altre informazioni...",
        overflow: TextOverflow.ellipsis,
      ),
      icon: Icons48(iconKey: vehicle.type,defaultKey: "OTHER_VEHICLE",),
      //todo: push VehicleDetails if in normal opeation, push InsertExpense if user is selecting a widget for expense Insertion
      //probably better if onTap is defined by VehicleList
      //BlocFunction.INSERT_EXPENSE
      /*InsertExpense needs an Expense bloc with vehicle != null, in case no vehicle is provided to ExpenseList
              * we return the selected vehicle to the calling page (ExpenseList) and then
              * encapsulate the InsertExpense widget in a BlobProvider equiped with a Vehicle selected by tapping on this tile*/
      //return BlocProvider(child: InsertExpense(), bloc: ExpenseBloc(vehicle: vehicle),);

      onTap: () {
        if(vehicleBloc.function == BlocFunction.LIST){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VehicleDetails(vehicle: vehicle,),
            ),
          );
        }
        else{ //Insert Expense
          Navigator.pop(context, vehicle);
        }
      },

      deleteCallback: () => vehicleBloc.deleteVehicle(vehicle.guid),
      editCallback: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InsertVehicle(editVehicle: vehicle,),
        ),
      ),
    );
  }
}