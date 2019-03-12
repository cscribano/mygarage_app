import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
import 'package:mygarage/widgets/details_box_text.dart';

import '../blocs/expense_bloc.dart';
import '../models/vehiclemodel.dart';
import '../models/expensemodel.dart';
import '../pages/expenses_list.dart';
import '../widgets/bloc_provider.dart';

class VehicleDetails extends StatefulWidget{
  final Vehicle vehicle;
  VehicleDetails({@required this.vehicle});

  @override
  State<StatefulWidget> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails>{

  ExpenseEnum _expenseDetailsType = ExpenseEnum.ANY;

  @override
  Widget build(BuildContext context) {
    Translations translation = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('home_title')),
/*        actions: <Widget>[
          SyncButton(),
        ],*/
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
                children: <Widget>[
                  VehicleDetailsBox(vehicle: widget.vehicle,),
                  Text("Expenses type:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
                  /*Dropdown Expense type choice*/
                  Padding(
                    padding: EdgeInsets.only(top:10.0),
                    child:  DropdownButton<ExpenseEnum>(
                      items: ExpenseTypeToString(context).keys.map((ExpenseEnum value) {
                        return  DropdownMenuItem<ExpenseEnum>(
                          value: value,
                          child:  Text(ExpenseTypeToString(context)[value]),
                        );
                      }).toList(),
                      isDense: true,
                      onChanged: (Value) {
                        setState(() {
                          _expenseDetailsType = Value;
                        });
                      },
                      value: _expenseDetailsType,
                    ),
                  ),
                  /*Submit button, navigate to expenses page*/
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      child: Text("Show Vehicle's Expenses"),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            bloc: ExpenseBloc(vehicle: widget.vehicle, expenseType: _expenseDetailsType),
                            child: VehicleExpenses(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
      ),
      //drawer: BlocProvider(bloc: AuthBloc(), child: DefaultDrawer(highlitedVoice: 1,),),
    );
  }
}

String _capitalize(String s) => s != "" ? s[0].toUpperCase() + s.substring(1) : "[Missing text]";

class VehicleDetailsBox extends StatelessWidget{
  final Vehicle vehicle;
  VehicleDetailsBox({@required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: Text(
              _capitalize(vehicle.brand)+' '+_capitalize(vehicle.model),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child:DetailsBoxText(heading: "Type of vehicle",text: VehicleToString(context)[vehicle.type],),
              ),
              //MyVerticalDivider(),
              Expanded(
                child: DetailsBoxText(heading: "Type of Fuel",text: FuelToString(context)[vehicle.fuel],),
              ),
            ],
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DetailsBoxText(heading: "Model Year",text: vehicle.modelYear != null ? vehicle.modelYear.toString() : '-',),
              //MyVerticalDivider(),
              DetailsBoxText(heading: "Buying Price",text: vehicle.buyPrice != null ? vehicle.buyPrice.toStringAsFixed(2) : '-'),
            ],
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DetailsBoxText(heading: "Current Mileage",text: vehicle.currentOdo != null ? vehicle.currentOdo.toString() : '-',),
              //MyVerticalDivider(),
            ],
          ),
          Divider(color: Colors.black45,),
        ],
      ),
    );
  }
}