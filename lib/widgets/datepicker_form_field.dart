import 'package:flutter/material.dart';


String formDateFormat(DateTime d){
  return d.year.toString() + "-" + d.month.toString() + "-" + d.day.toString();
}

class DatePickerForm extends StatefulWidget{
  final String labelText;
  final Icon icon;
  final bool enabled;
  final String disabledText;
  final String Function(DateTime) validator;
  final void Function(DateTime) onSaved;

  DatePickerForm({Key key, this.labelText, this.icon, this.validator, this.enabled : true, this.disabledText, this.onSaved}) : super(key : key);

  @override
  State<StatefulWidget> createState() => _DatePicketFormState();

}

class _DatePicketFormState extends State<DatePickerForm>{

  @override
  Widget build(BuildContext context) {
    DateTime pickedDate = DateTime.now();

    return  FormField<DateTime>(
      initialValue: pickedDate,
      builder: (FormFieldState<DateTime> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.labelText,//"Date to pay until",
            icon: widget.icon,//Icon(Icons.calendar_today),
            errorText: state.hasError ? state.errorText : null,
          ),
          child:  GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              if(widget.enabled){
                DateTime newDate = await selectDate(context);
                if(newDate != null) {
                  pickedDate = newDate;
                  state.didChange(newDate);
                }
              }
            },
            child: Container(
              child: Text(widget.enabled ? formDateFormat(state.value) : widget.disabledText),
            ),
          ),
        );
      },
      //validator: null,
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }

  Future<DateTime> selectDate(BuildContext context){
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );
  }
}