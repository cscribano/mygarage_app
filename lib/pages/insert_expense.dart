import 'package:auto_size_text/auto_size_text.dart';

import '../widgets/dropdown_form_field.dart';
import '../widgets/icons.dart';
import '../widgets/bloc_provider.dart';
import '../widgets/datepicker_form_field.dart';
import '../blocs/expense_bloc.dart';
import '../models/expensemodel.dart';
import '../models/vehiclemodel.dart';

import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
import 'dart:core';

class InsertExpense extends StatefulWidget{
  final Expense editExpense;
  InsertExpense({this.editExpense});

  @override
  State<StatefulWidget> createState() => _InsertExpenseState();

}

class _InsertExpenseState extends State<InsertExpense>{

  final _formKey = GlobalKey<FormState>();
  Translations translation;
  bool isPaid = false;

  @override
  Widget build(BuildContext context) {
    translation = Translations.of(context);
    final ExpenseBloc  _expenseBloc = BlocProvider.of<ExpenseBloc>(context);
    final expenseTypeString = ExpenseTypeToString(context)[_expenseBloc.expenseType];
    final Expense _newExpense = widget.editExpense== null ? Expense.create(vehicle: _expenseBloc.vehicle.guid, expenseType: _expenseBloc.expenseType) : widget.editExpense;

    isPaid = _newExpense.datePaid != null;

    final String _pageTitle = (widget.editExpense== null ? "Insert " : "Edit ") + expenseTypeString;

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
          child: Container(
            //height: 500,
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                categoryFormField(_newExpense, _expenseBloc.expenseType),
                detailsFormField(_newExpense),
                dateToPayFormField(_newExpense),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: datePayFormField(context, _newExpense),
                      ),
                      Checkbox(
                        value: isPaid,
                        onChanged: (value) => setState(() {
                          isPaid = value;
                        }),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                ),
                priceFormField(_newExpense),
                Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: RaisedButton(
                    child: Text(translation.text('vehicle_insert_submit_btn')),
                    onPressed: () => _submitForm(_newExpense),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownFormField categoryFormField(Expense newExpense, ExpenseEnum expenseType){
    return DropdownFormField(
      iconProvider: (key) => Icons24(iconKey: key, color: Colors.black45,defaultkey: "OTHER_"+eeToString(expenseType),),
      values: ExpenseCategoryToString(context, expenseType),
      initialValue: newExpense.expenseCategory,
      onSaved: (val) => newExpense.expenseCategory = val,
    );
  }

  TextFormField detailsFormField(Expense newExpense){
    return TextFormField(
      decoration: InputDecoration(
        icon: Icons24(iconKey: "OTHER_INSERT", color: Colors.black45),
        hintText: "Insert expense description", //translation.text('vehicle_insert_hint_manufacturer'),
        labelText: 'Description',
      ),
      validator:textValidator,
      initialValue: newExpense.details,
      onSaved: (val) => newExpense.details = val,
    );
  }

  DatePickerForm dateToPayFormField(Expense newExpense){
    return DatePickerForm(
      labelText: "To pay until",
      icon: Icon(Icons.calendar_today),
      initialValue: newExpense.dateToPay,
      validator: null,
      onSaved: (val) => newExpense.dateToPay = val,
    );
  }

  DatePickerForm datePayFormField(BuildContext context, Expense newExpense){
    return DatePickerForm(
      labelText: "Paid on",
      icon: Icon(Icons.calendar_today),
      validator: null,
      enabled: this.isPaid,
      initialValue: newExpense.datePaid,
      disabledText: "Not Paid yet",
      onSaved: (val) => isPaid ? newExpense.datePaid = val : newExpense.datePaid = null,
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

  void _submitForm(Expense newExpense){
    final FormState form = _formKey.currentState;
    final ExpenseBloc  expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      expenseBloc.addExpense(newExpense);
      Navigator.of(context).pop();
    }
  }
}