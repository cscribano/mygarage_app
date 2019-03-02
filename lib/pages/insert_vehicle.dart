import 'package:flutter/material.dart';
import 'dart:core';

import '../widgets/dropdown_form_field.dart';
import '../widgets/icons.dart';
import '../widgets/bloc_provider.dart';
import '../blocs/vehicle_bloc.dart';
import '../models/vehiclemodel.dart';

class InsertVehicle extends StatefulWidget{
  final Vehicle editVehicle;
  InsertVehicle({this.editVehicle});

  @override
  State<StatefulWidget> createState() => _InsertVehicleState();
}

class _InsertVehicleState extends State<InsertVehicle>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Vehicle _newVehicle = widget.editVehicle == null ? Vehicle.create() : widget.editVehicle;

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
                typeFormField(_newVehicle),
                brandFormField(_newVehicle),
                modelFormField(_newVehicle),
                modelYearFormField(_newVehicle),
                fuelFormField(_newVehicle),
                odoFormField(_newVehicle),
                priceFormField(_newVehicle),

                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: RaisedButton(
                    child: const Text('Submit'),
                    onPressed: () => _submitForm(_newVehicle),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownFormField typeFormField(Vehicle newVehicle){
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
      initialValue: newVehicle.type,
      onSaved: (val) => newVehicle.type = val,
    );
  }

  TextFormField brandFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "MANUFACTURER", color: Colors.black45),
        hintText: 'Enther the vehicle\'s manufacturer',
        //labelText: 'Name',
      ),
      validator:textValidator,
      initialValue: newVehicle.brand,
      onSaved: (val) => newVehicle.brand = val,
    );
  }

  TextFormField modelFormField(Vehicle newVehicle) {
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "OTHER", color: Colors.black45),
        hintText: 'Enther the vehicle\'s model',
        //labelText: 'Name',
      ),
      validator:textValidator,
      initialValue: newVehicle.model,
      onSaved: (val) => newVehicle.model = val,
    );
  }

  TextFormField modelYearFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "DATEYEAR", color: Colors.black45),
        hintText: 'Enther the vehicle\'s model year',
        //labelText: 'Name',
      ),
      validator: (value){
        if(double.tryParse(value) != null){
          if(double.tryParse(value)%1 != 0){
            return("Date must be an integer value!");
          }
          if(int.tryParse(value) < 1800 || int.tryParse(value) > DateTime.now().year){
            return("Date must be between 1800 and $DateTime.now().year");
          }
          if (value.length == 0) {
            return ('This field is required');
          }
        }
      },
      onSaved: (val) => newVehicle.modelYear = int.tryParse(val),
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      initialValue: newVehicle.modelYear != null ? newVehicle.modelYear.toString() : null,
    );
  }


/*FUEL_CAT = ["GAS", "DIESEL", "EV", "LPG", "METHANE", "HYBRID", "OTHER"]*/
  DropdownFormField fuelFormField(Vehicle newVehicle){
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
      onSaved: (val) => newVehicle.fuel = val,
      initialValue: newVehicle.fuel,
    );
  }

  TextFormField odoFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "MILES", color: Colors.black45),
        hintText: 'Enther the vehicle\'s current mileage',
        //labelText: 'Name',
      ),
      onSaved: (val) => newVehicle.currentOdo = int.tryParse(val),
      validator: (val){
        if(double.tryParse(val) != null){
          if(double.parse(val)%1 != 0){
            return("Mileage must be an integer value");
          }
        }
      },
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      initialValue: newVehicle.currentOdo != null ? newVehicle.currentOdo.toString() : null,
    );
  }

  TextFormField priceFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: InsertVehicleIcons24(iconKey: "PRICE", color: Colors.black45),
        hintText: 'Enther the vehicle\'s buyng price',
        //labelText: 'Name',
      ),
      onSaved: (val) => newVehicle.buyPrice = double.tryParse(val),
      validator: (val){
        if(double.tryParse(val) != null){
          return double.parse(val) < 0 ? "The price must be a positive number" : null;
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
      initialValue: newVehicle.buyPrice != null ? newVehicle.buyPrice.toString() : null,
    );
  }

   String textValidator(String value){
     if (value.length == 0) {
       return ('This field is required');
     }
     if(!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)){ //todo:allow space but not space only
       return ('Special characters are not allowed');
     }
   }

  void _submitForm(Vehicle newVehicle){
    final FormState form = _formKey.currentState;
    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(_formKey.currentContext);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      vehicleBloc.addVehicle(newVehicle);
      Navigator.of(context).pop();
    }
  }
}
