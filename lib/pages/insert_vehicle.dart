import 'package:flutter/material.dart';
import 'dart:core';

import '../widgets/dropdown_form_field.dart';
import '../widgets/icons.dart';
import '../widgets/bloc_provider.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehiclemodel.dart';

class InsertVehicle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _InsertVehicleState();
}

class _InsertVehicleState extends State<InsertVehicle>{

  final _formKey = GlobalKey<FormState>();
  final Vehicle _newVehicle = Vehicle.create();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Vehicle"),
        actions: <Widget>[
          //SyncButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            height: 500,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                typeFormField(),
                brandFormField(),
                modelFormField(),
                modelYearFormField(),
                fuelFormField(),
                odoFormField(),
                priceFormField(),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: const Text('Submit'),
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownFormField typeFormField(){
    return DropdownFormField(
      iconProvider: (key) => VehicleIcons24(iconKey: key, color: Colors.black45),
      values: {
        "CAR" : "Car",
        "BIKE" :"Motorcycle",
        "VAN" : "Van",
        "RV" : "Recreational Vehicle",
        "AGRO" : "Agricultural Vehicle",
        "OTHER" : "Other",
      },
      onSaved: (val) => _newVehicle.type = val,
    );
  }

  TextFormField brandFormField(){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "MANUFACTURER", color: Colors.black45),
        hintText: 'Enther the vehicle\'s manufacturer',
        //labelText: 'Name',
      ),
      validator:textValidator,
      onSaved: (val) => _newVehicle.brand = val,
    );
  }

  TextFormField modelFormField() {
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "OTHER", color: Colors.black45),
        hintText: 'Enther the vehicle\'s model',
        //labelText: 'Name',
      ),
      validator:textValidator,
      onSaved: (val) => _newVehicle.model = val,
    );
  }

  TextFormField modelYearFormField(){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "DATEYEAR", color: Colors.black45),
        hintText: 'Enther the vehicle\'s model year',
        //labelText: 'Name',
      ),
      validator: (value){
        if(double.tryParse(value)%1 != 0){
          return("Date must be an integer value!");
        }
        if(int.tryParse(value) < 1800 || int.tryParse(value) > DateTime.now().year){
          return("Date must be between 1800 and $DateTime.now().year");
        }
        if (value.length == 0) {
          return ('This field is required');
        }
      },
      onSaved: (val) => _newVehicle.modelYear = int.tryParse(val),
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
    );
  }


/*FUEL_CAT = ["GAS", "DIESEL", "EV", "LPG", "METHANE", "HYBRID", "OTHER"]*/
  DropdownFormField fuelFormField(){
    return DropdownFormField(
      icon: InsertVehicleIcons24(iconKey: "FUEL", color: Colors.black45),
      values: {
        "GAS" : "Gasoline",
        "DIESEL" :"Diesel",
        "EV" : "Elettrict Vehicle",
        "LPG" : "Liquid Propane Gas",
        "METHANE" : "Methane",
        "HYBRID" : "Hybrid Vehicle",
        "OTEHR" : "Other",
      },
      onSaved: (val) => _newVehicle.fuel = val,
    );
  }

  TextFormField odoFormField(){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "MILES", color: Colors.black45),
        hintText: 'Enther the vehicle\'s current mileage',
        //labelText: 'Name',
      ),
      onSaved: (val) => _newVehicle.currentOdo = int.tryParse(val),
      validator: (val){
        if(double.parse(val)%1 != 0){
          return("Mileage must be an integer value");
        }
      },
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
    );
  }

  TextFormField priceFormField(){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "PRICE", color: Colors.black45),
        hintText: 'Enther the vehicle\'s buyng price',
        //labelText: 'Name',
      ),
      onSaved: (val) => _newVehicle.buyPrice = double.tryParse(val),
      validator: (val) => double.parse(val) < 0 ? "The price must be a positive number" : null,
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
    );
  }

   String textValidator(String value){
     if (value.length == 0) {
       return ('This field is required');
     }
     if(!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)){
       return ('Special characters are not allowed');
     }
   }

  void _submitForm(){
    final FormState form = _formKey.currentState;
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(_formKey.currentContext);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      vehicleBloc.addVehicle(_newVehicle);
      //this.widget.presenter.onCalculateClicked(_weight, _height);
    }
  }
}
