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
  final String tag;
  ExpenseEnum expenseType = ExpenseEnum.ANY;

  ExpenseBloc({this.vehicle, this.expenseType, this.tag}){
    print("Constructor $tag");
    getExpenses();
  }

  void getExpenses() async{
    print("GetExpenses $tag");
    if(vehicle != null){
      //Get all expenses (paper, work) for vehicle
      var expenses = await _db.getAllExpenses(vehicle:this.vehicle.guid, type: expenseType);
      _inExpense.add(expenses);
    }
    else{
      //get all expenses for any vehicle
      var expenses = await _db.getAllExpenses(type: expenseType);
      _inExpense.add(expenses);
    }
  }

  void markAsDeleted(Expense e) async {
    await _db.markAsDeleted(e.guid);
    getExpenses();
  }

  void addExpense(Expense newExpense) async {
    await _db.upsert(newExpense);
    getExpenses();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //await _expenseController.stream.drain();
    _expenseController.close();
  }

}