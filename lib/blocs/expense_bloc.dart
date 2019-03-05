import '../models/expensemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/db_providers/expense_provider.dart';

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';


class ExpenseBloc implements BlocBase{

  StreamController<List<Expense>> _expenseController = StreamController<List<Expense>>.broadcast();
  Sink<List<Expense>> get _inExpense => _expenseController.sink;
  Stream<List<Expense>> get outExpense => _expenseController.stream;

  final ExpenseProvider _db = ExpenseProvider();
  final String vehicle;

  ExpenseBloc({@required this.vehicle}){
    getExpenses();
  }

  void getExpenses() async{
    _inExpense.add(await _db.getAllVehicleExpenses(this.vehicle));
  }

  void addRandom() async{
    //_db.insertRandom();
    //Expense newExpense = Expense.create(vehicle: vehicle, innerText: "Hello"+"Helloworld"+Random().nextInt(1000).toString(), innerNum: Random().nextInt(10000));
    Expense newExpense = Expense.create(vehicle: vehicle, expenseClass: "WORK", expenseCategory: "ENGINE", details:"", dateToPay: DateTime.now(), datePaid: DateTime.now(), cost: Random().nextDouble(), paid: Random().nextDouble());
    await _db.upsert(newExpense);
    getExpenses();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _expenseController.close();
  }

}