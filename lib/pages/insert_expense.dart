import 'package:auto_size_text/auto_size_text.dart';

import '../widgets/dropdown_form_field.dart';
import '../widgets/icons.dart';
import '../widgets/bloc_provider.dart';
import '../blocs/expense_bloc.dart';
import '../models/expensemodel.dart';
import '../models/vehiclemodel.dart';

import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
import 'dart:core';

String formDateFormat(DateTime d){
  return d.year.toString() + "-" + d.month.toString() + "-" + d.day.toString();
}

class InsertExpense extends StatefulWidget{
  final Expense editExpense;
  InsertExpense({this.editExpense});

  @override
  State<StatefulWidget> createState() => _InsertExpenseState();

}

class _InsertExpenseState extends State<InsertExpense>{

  final _formKey = GlobalKey<FormState>();
  Translations translation;

  @override
  Widget build(BuildContext context) {
    final translation = Translations.of(context);
    final Expense _newExpense = widget.editExpense== null ? Expense.create() : widget.editExpense;
    final ExpenseBloc  _expenseBloc = BlocProvider.of<ExpenseBloc>(context);
    final expenseType = ExpenseTypeToString(context)[_expenseBloc.expenseType];

    final String _pageTitle = (widget.editExpense== null ? "Insert " : "Edit ") + expenseType;

    return Scaffold(

      appBar: AppBar(
        title:  AutoSizeText(_pageTitle, maxLines: 1,), //todo: different if we are editing
        actions: <Widget>[
          //SyncButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              //height: 500,
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Text(_expenseBloc.expenseType.toString()),
                  typeFormField(_newExpense),
                  detailsFormField(_newExpense),
                  dateToPayFormField(context, _newExpense),
                  datePayFormField(context, _newExpense),
                  priceFormField(_newExpense),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      child: Text(translation.text('vehicle_insert_submit_btn')),
                      onPressed: null,//() => _submitForm(_newVehicle),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownFormField typeFormField(Expense newExpense){
    return DropdownFormField(
      iconProvider: (key) => Icons24(iconKey: key, color: Colors.black45,defaultkey: "OTHER_WORK",),
      values: VehicleToString(context),
      initialValue: newExpense.expenseType,
      onSaved: (val) => newExpense.expenseType = val,
    );
  }

  TextFormField detailsFormField(Expense newExpense){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icons24(iconKey: "OTHER_INSERT", color: Colors.black45),
        hintText: "Insert expense description", //translation.text('vehicle_insert_hint_manufacturer'),
        labelText: 'Name',
      ),
      validator:textValidator,
      initialValue: newExpense.details,
      onSaved: (val) => newExpense.details = val,
    );
  }

  FormField dateToPayFormField(BuildContext context, Expense newExpense){
    DateTime pickedDate = DateTime.now();

    return  FormField<DateTime>(
      initialValue: pickedDate,
      builder: (FormFieldState<DateTime> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Date to pay until",
            icon: Icon(Icons.calendar_today),
            errorText: state.hasError ? state.errorText : null,
          ),
          child:  GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              DateTime newDate = await selectDate(context);
              pickedDate = newDate;
              state.didChange(newDate);
            },
            child: Container(
              child: Text(formDateFormat(state.value)),
            ),
          ),
        );
      },
      //validator: null,
      validator:null,// widget.validator,
      onSaved: null,//widget.onSaved,
    );
  }

  FormField datePayFormField(BuildContext context, Expense newExpense){
    DateTime pickedDate = DateTime.now();

    return  FormField<DateTime>(
      initialValue: pickedDate,
      builder: (FormFieldState<DateTime> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Date Payid on",
            icon: Icon(Icons.calendar_today),
            errorText: state.hasError ? state.errorText : null,
          ),
          child:  GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              DateTime newDate = await selectDate(context);
              pickedDate = newDate;
              state.didChange(newDate);
            },
            child: Container(
              child: Text(formDateFormat(state.value)),
            ),
          ),
        );
      },
      //validator: null,
      validator:null,// widget.validator,
      onSaved: null,//widget.onSaved,
    );
  }

  TextFormField priceFormField(Expense newExpense){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icons24(iconKey: "PRICE", color: Colors.black45),
        hintText: "Insert expense cost",//translation.text('vehicle_insert_hint_price'),
        labelText: "Cost",//translation.text("vehicle_insert_label_price"),
        //labelText: 'Name',
      ),
      onSaved: (val) => newExpense.cost = double.tryParse(val),
      validator: (val){
        if(double.tryParse(val) != null){
          return double.parse(val) < 0 ? translation.text('vehicle_insert_invalid_price_positive') : null;
        }
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: false),
      initialValue: newExpense.cost != null ? newExpense.cost.toString() : null,
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

  String textValidator(String value){
    if (value.length == 0) {
      return (translation.text('vehicle_insert_invalid_text_required'));
    }
    if(value.length > 25){
      return "This field must be up to 25 chacarters";
    }
    if(!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(value)){ //todo:allow space but not space only
      return (translation.text('vehicle_insert_invalid_text_specialchar'));
    }
  }
}