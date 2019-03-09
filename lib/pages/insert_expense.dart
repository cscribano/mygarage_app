import '../widgets/dropdown_form_field.dart';
import '../widgets/icons.dart';
import '../widgets/bloc_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    translation = Translations.of(context);
    final Expense _newExpense = widget.editExpense== null ? Expense.create() : widget.editExpense;
    final ExpenseBloc  _expenseBloc = BlocProvider.of<ExpenseBloc>(context);

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
                Text(_expenseBloc.vehicle.guid),
                /*typeFormField(_newVehicle),
                brandFormField(_newVehicle),
                modelFormField(_newVehicle),
                modelYearFormField(_newVehicle),
                fuelFormField(_newVehicle),
                odoFormField(_newVehicle),
                priceFormField(_newVehicle),
                */

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
    );
  }
}