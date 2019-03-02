import '../models/vehiclemodel.dart';
import '../blocs/expense_bloc.dart';
import '../widgets/bloc_provider.dart';
import '../pages/expenses_list.dart';
import '../blocs/vehicle_bloc.dart';
import '../pages/insert_vehicle.dart';
import 'icons.dart';

import 'package:flutter/material.dart';

String _capitalize(String s) => s[0].toUpperCase() + s.substring(1); //Unsafe in string is empty

class VehicleTile extends StatelessWidget{

  final Vehicle vehicle;
  VehicleTile({Key key, this.vehicle}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);

    return MyGarageTile(
      text: _capitalize(vehicle.brand) + " " +_capitalize(vehicle.model),
      subtext: "Altre informazioni...",
      icon: VehicleIcons48(iconKey: vehicle.type,),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(bloc: ExpenseBloc(vehicle: vehicle.guid), child: VehicleExpenses(),),
          ),
        );
      },
      deleteCallback: () => vehicleBloc.deleteVehicle(vehicle.guid),
      editCallback: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InsertVehicle(editVehicle: vehicle,)
          ),
        );
      },
    );
  }
}


class MyGarageTile extends StatelessWidget{

  //final Vehicle vehicle;
  final Icon icon;
  final String text;
  final String subtext;
  final void Function() onTap;
  final void Function() deleteCallback;
  final void Function() editCallback;
  MyGarageTile({this.text, this.subtext, this.icon, this.onTap, this.deleteCallback, this.editCallback});

  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showActionsMenu(BuildContext context){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size   // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: () =>_showDeleteDialog(context),
          child: Text("Delete"),
        ),
        PopupMenuItem(
          value: editCallback,
          child: Text("Edit"),//this._index,
        )
      ],
      context: context,
    ).then((value) => value());
  }

  void _showDeleteDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("Are you sure you want to delete this item?"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: (){
                  deleteCallback();
                  Navigator.of(context).pop();
                },//null,//() => Navigator.of(_cxt).pushReplacementNamed("/Login"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTapDown: _storePosition,
      onTap: onTap,
      onLongPress: () => _showActionsMenu(context),

      child: Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(text, style: TextStyle(fontWeight: FontWeight.bold,),),
                Text(subtext),
              ],
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.yellow[300],
              child: Container(margin: EdgeInsets.all(5.0),child: icon,),
            ),
          ),
        ),
      ),

    );
  }
}

/*
*   RelativeRect buttonMenuPosition(BuildContext c) {
    final RenderBox bar = c.findRenderObject();
    final RenderBox overlay = Overlay.of(c).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bar.localToGlobal(bar.size.center(Offset.zero), ancestor: overlay),
        bar.localToGlobal(bar.size.center(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }
* */