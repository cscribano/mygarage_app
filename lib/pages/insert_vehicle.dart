import 'package:flutter/material.dart';
import '../widgets/icons.dart';

class InsertVehicle extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _InsertVehicleState();
}

class _InsertVehicleState extends State<InsertVehicle>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Insert Vehicle"),
          actions: <Widget>[
            //SyncButton(),
          ],
        ),
        body: Container(
          //color: Colors.grey.shade300,
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  typeFormField(),
                  DropdownFormField(values: ["CAR", "B", "D"],),
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
        )
    );
  }

  TextFormField typeFormField(){
    return TextFormField(
      decoration: const InputDecoration(
        icon: const Icon(Icons.person),
        hintText: 'Enter your first and last name',
        //labelText: 'Name',
      ),
      onSaved: (val) => print(val),
    );
  }

  void _submitForm(){
    final FormState form = _formKey.currentState;
    form.save();
  }
}

class DropdownFormField extends StatefulWidget{

  final List<String> values;
  DropdownFormField({key, this.values}) : super(key:key);

  @override
  State<StatefulWidget> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField>{

  String _currentValue;

  @override
  void initState() {
    _currentValue = widget.values.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: VehicleIcons24(vehicleType: _currentValue),
            errorText: state.hasError ? state.errorText : null,
          ),
          //isEmpty: _currentValue == 'A',
          child:  DropdownButtonHideUnderline(
            child:  DropdownButton<String>(
              value: _currentValue,
              isDense: true,
              onChanged: (String Value) {
                setState(() {
                  //Contact.favoriteColor = Value;
                  _currentValue = Value;
                  state.didChange(Value);
                });
              },
              items: widget.values.map((String value) {
                return  DropdownMenuItem<String>(
                  value: value,
                  child:  Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
      onSaved: (val) => print(val), //ATTENZIONE!! Se submit senza scelta si ha null! (fixare)
    );
  }

}