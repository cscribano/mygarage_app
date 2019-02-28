import '../models/vehiclemodel.dart';
import '../blocs/vehicle_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../widgets/bloc_provider.dart';
import '../pages/expenses_list.dart';

import 'package:flutter/material.dart';

class VehicleIcons extends StatelessWidget{

  static final String baseIconsPath = "assets/icons/";

  static final Map<String, String> _type2Pic = {
    "CAR" : "icons8-fiat-500-48.png",
    "BIKE" : "icons8-motorcycle-48.png",
    "VAN" : "icons8-van-48.png",
    "RV" : "icons8-camper-48.png",
    "AGRO" : "icons8-tractor-48.png",
    "BOAT" : "icons8-sailing-ship-48.png",
    "OTHER" : "icons8-rocket-48.png",
  };

  final String vehicleType;
  VehicleIcons({this.vehicleType});

  @override
  Widget build(BuildContext context) {
    if(_type2Pic.containsKey(vehicleType.toUpperCase())){
      return Image.asset(baseIconsPath+_type2Pic[vehicleType.toUpperCase()]);
    }
    return Image.asset(baseIconsPath+_type2Pic["OTHER"]);
  }

}

class VehicleTile extends StatelessWidget{

  final Vehicle vehicle;
  VehicleTile({this.vehicle});

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);

    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
        child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_capitalize(vehicle.brand) + " " +_capitalize(vehicle.model), style: TextStyle(fontWeight: FontWeight.bold,),),
                Text("Altre informazioni....")
              ],
            ),
            //leading: Text(vehicle.buyPrice.toString() + "€"),
            leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.yellow[300],
                child: Container(margin: EdgeInsets.all(5.0),child: VehicleIcons(vehicleType: vehicle.type,),)
            ),
            /*trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => vehicleBloc.deleteVehicle(vehicle.guid),
            ),*/
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(bloc: ExpenseBloc(vehicle: vehicle.guid), child: VehicleExpenses(),),
                ),
              );
            }
        ),
      ),
    );
  }
}