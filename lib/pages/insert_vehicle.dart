import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
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
  Translations translation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    translation = Translations.of(context);
    final Vehicle _newVehicle = widget.editVehicle == null ? Vehicle.create() : widget.editVehicle;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.text('vehicle_insert_title')), //todo: different if we are editing
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
                    child: Text(translation.text('vehicle_insert_submit_btn')),
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
      iconProvider: (key) => Icons24(iconKey: key, color: Colors.black45,defaultkey: "OTHER_VEHICLE",),
      values: VehicleToString(context),
      initialValue: newVehicle.type,
      onSaved: (val) => newVehicle.type = val,
    );
  }

  TextFormField brandFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icons24(iconKey: "MANUFACTURER", color: Colors.black45),
        hintText: translation.text('vehicle_insert_hint_manufacturer'),
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
        icon: Icons24(iconKey: "OTHER_INSERT", color: Colors.black45),
        hintText: translation.text('vehicle_insert_hint_model'),
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
        icon: Icons24(iconKey: "DATEYEAR", color: Colors.black45),
        hintText: translation.text('vehicle_insert_hint_model'),
        //labelText: 'Name',
      ),
      validator: (value){
        if(double.tryParse(value) != null){
          if(double.tryParse(value)%1 != 0){
            return(translation.text('vehicle_insert_invalid_date_integer'));
          }
          if(int.tryParse(value) < 1800 || int.tryParse(value) > DateTime.now().year){
            return(translation.text('vehicle_insert_invalid_date_between')+" $DateTime.now().year");
          }
          if (value.length == 0) {
            return (translation.text('vehicle_insert_invalid_date_required'));
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
      icon: Icons24(iconKey: "FUEL", color: Colors.black45),
      values: FuelToString(context),
      onSaved: (val) => newVehicle.fuel = val,
      initialValue: newVehicle.fuel,
    );
  }

  TextFormField odoFormField(Vehicle newVehicle){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icons24(iconKey: "MILES", color: Colors.black45),
        hintText: translation.text('vehicle_insert_hint_mileage'),
        //labelText: 'Name',
      ),
      onSaved: (val) => newVehicle.currentOdo = int.tryParse(val),
      validator: (val){
        if(double.tryParse(val) != null){
          if(double.parse(val)%1 != 0){
            return(translation.text('vehicle_insert_invalid_mileage_integer'));
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
        icon: Icons24(iconKey: "PRICE", color: Colors.black45),
        hintText: translation.text('vehicle_insert_hint_price'),
        //labelText: 'Name',
      ),
      onSaved: (val) => newVehicle.buyPrice = double.tryParse(val),
      validator: (val){
        if(double.tryParse(val) != null){
          return double.parse(val) < 0 ? translation.text('vehicle_insert_invalid_price_positive') : null;
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
      initialValue: newVehicle.buyPrice != null ? newVehicle.buyPrice.toString() : null,
    );
  }

   String textValidator(String value){
     if (value.length == 0) {
       return (translation.text('vehicle_insert_invalid_text_required'));
     }
     if(!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)){ //todo:allow space but not space only
       return (translation.text('vehicle_insert_invalid_text_specialchar'));
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
