import 'icons.dart';
import 'package:flutter/material.dart';

class DropdownFormField extends StatefulWidget{

  final Map<String, String> values;
  final void Function(dynamic val) onSaved;
  final FormFieldValidator validator;
  final IconProvider Function(String key) iconProvider;
  final Icon icon;
  String initialValue;
  DropdownFormField({key, this.values, this.onSaved, this.validator, this.iconProvider, this.icon, this.initialValue}) : super(key:key);

  @override
  State<StatefulWidget> createState() => _DropdownFormFieldState();
}

class _DropdownFormFieldState extends State<DropdownFormField>{

  String _currentValue;

  @override
  void initState() {
    _currentValue = widget.initialValue == null ? widget.values.keys.first : widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  FormField<String>(
      initialValue: _currentValue,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: widget.iconProvider != null ? widget.iconProvider(_currentValue) : widget.icon,
            errorText: state.hasError ? state.errorText : null,
          ),
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
              items: widget.values.keys.map((String value) {
                return  DropdownMenuItem<String>(
                  value: value,
                  child:  Text(widget.values[value]),
                );
              }).toList(),
            ),
          ),
        );
      },
      //validator: null,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}