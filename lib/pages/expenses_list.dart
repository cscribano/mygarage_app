import '../widgets/bloc_provider.dart';
import '../blocs/expense_bloc.dart';
import '../models/expensemodel.dart';
import '../widgets/garage_tiles.dart';

import 'package:flutter/material.dart';

class VehicleExpenses extends StatefulWidget{
  //final String vehicle;

  //VehicleExpenses({Key key, @required this.vehicle}) : super(key: key);
  VehicleExpenses({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VehicleExpensesState();
}

class _VehicleExpensesState extends State<VehicleExpenses>{

  @override
  Widget build(BuildContext context) {

    final ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(expenseBloc.vehicle)//Text("Spese Veicolo"),
      ),
      body: Center(
        child: StreamBuilder(
            stream: expenseBloc.outExpense,//bloc.allVehicles,
            builder: (context, AsyncSnapshot<List<Expense>> snapshot){
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if (!snapshot.hasData){
                expenseBloc.getExpenses();
                return CircularProgressIndicator();
              }
              else if(snapshot.hasData && snapshot.data.length == 0){
                return Text("No expenses here!");
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Expense item = snapshot.data[index];
                  return ExpenseTile(expense: item,);
                },
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: expenseBloc.addRandom,
      ),
    );
  }
}