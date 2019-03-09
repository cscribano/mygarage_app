import '../models/expensemodel.dart';
import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/db_providers/expense_provider.dart';

import 'dart:async';

//Expense types: PAPER, WORK
class ExpenseBloc implements BlocBase{

  StreamController<List<Expense>> _expenseController = StreamController<List<Expense>>.broadcast();
  Sink<List<Expense>> get _inExpense => _expenseController.sink;
  Stream<List<Expense>> get outExpense => _expenseController.stream;

  final ExpenseProvider _db = ExpenseProvider();

  final Vehicle vehicle;
  ExpenseEnum expenseType = ExpenseEnum.ANY;

  ExpenseBloc({this.vehicle, this.expenseType}){
    getExpenses();
  }

  void getExpenses() async{
    if(vehicle != null){
      //Get all expenses (paper, work) for vehicle
      _inExpense.add(await _db.getAllExpenses(vehicle:this.vehicle.guid, type: expenseType));
    }
    else{
      //get all expenses for any vehicle
      _inExpense.add(await _db.getAllExpenses(type: expenseType));
    }
  }

  void markAsDeleted(Expense e) async {
    var ret = _db.markAsDeleted(e.guid);
    getExpenses();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _expenseController.close();
  }

}