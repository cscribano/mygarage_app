import '../blocs/expense_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../models/expensemodel.dart';

import '../widgets/bloc_provider.dart';
import '../widgets/garage_tiles.dart';
import '../widgets/empty_placeholder.dart';
import '../widgets/default_drawer.dart';

import 'package:flutter/material.dart';

class VehicleExpenses extends StatefulWidget{
  final int drawerEntry;
  VehicleExpenses({Key key, this.drawerEntry}) : super(key:key);

  @override
  State<StatefulWidget> createState() => _VehicleExpensesState();
}

//EXPENSE_TYPE = ["PAPER", "WORK"]
class _VehicleExpensesState extends State<VehicleExpenses>{

  @override
  Widget build(BuildContext context) {

    final ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("PROVA")//Text("Spese Veicolo"),
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
                return EmptyPlaceHolder(
                  image:Image.asset('assets/icons/big/icons8-maintenance-96.png', color: Colors.black45,),
                  fontSize: 20,
                  text: "Ad a New Expense",
                );
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
        onPressed: null,//expenseBloc.addRandom,
      ),
      drawer: Navigator.of(context).canPop() ? null : BlocProvider(child: DefaultDrawer(highlitedVoice: widget.drawerEntry?? 3,), bloc: AuthBloc()),
    );
  }
}