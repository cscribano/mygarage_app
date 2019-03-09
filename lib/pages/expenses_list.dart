
import '../blocs/expense_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/vehicle_bloc.dart';

import '../models/expensemodel.dart';

import '../widgets/bloc_provider.dart';
import '../widgets/garage_tiles.dart';
import '../widgets/empty_placeholder.dart';
import '../widgets/default_drawer.dart';
import '../widgets/icons.dart';
import '../widgets/fancy_fab.dart';
import 'package:mygarage/widgets/sync_widgets.dart';

import 'vehicles_list.dart';
import 'insert_expense.dart';

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
        title: Text("PROVA"),//Text("Spese Veicolo"),
        actions: <Widget>[
          SyncButton(
            thenCallback: () => expenseBloc.getExpenses(),
          ),
        ],
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
                  //Todo: make this expense type aware (e.g different text/icons for different expenses types)
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

      floatingActionButton: FancyFab(
        icon: Icon(Icons.add),
        /*If Expense type is 'ANY' the FAB will be Expanded to allow the user to choice che kind of
        * expense (Repair, Paper...) to be added*/
        onPressed: expenseBloc.expenseType == ExpenseEnum.ANY ? null : () => dialogIfNoVehicle(context),
        children: <FloatingActionButton>[
          FloatingActionButton(
            /*This hero tag is MANDATORY to avoid getting crazy Exceptions!*/
            heroTag: "btn1",
            child: Icon(Icons.build),
            onPressed: null,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            child: Icon(Icons.payment),
            onPressed: null,
          )
        ],
      ),
      drawer: Navigator.of(context).canPop() ? null : BlocProvider(child: DefaultDrawer(highlitedVoice: widget.drawerEntry?? 3,), bloc: AuthBloc()),
    );
  }

  void dialogIfNoVehicle (BuildContext context){
    final ExpenseBloc expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    /*Expenses must be added to a vehicle, if no vehicle have been selected (seeing all expenses)
          an alert is prompted to allow the user to select a Vehicle from VehicleList,
          after tapping the chosen vehicle the InsertExpense page is Shown*/
    if(expenseBloc.vehicle != null){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => BlocProvider(child: InsertExpense(), bloc: expenseBloc,)
        ),
      );
    }
    else{
      _noVehicleAlert(context);
    }
  }

  void _noVehicleAlert(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Select a Vehicle"),
          content: Text("No vehicle have been selected, press continue to select a vehicle"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Back"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Continue"),
              onPressed: (){
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(child: VehiclesList(),bloc: VehicleBloc(function: BlocFunction.INSERT_EXPENSE),),
                  ),
                );
              }
            ),
          ],
        );
      },
    );
  }
}

class ExpenseTile extends StatelessWidget{
  final Expense expense;
  ExpenseTile({Key key, this.expense}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    return MyGarageTile(
      text: Text(capitalize(expense.details)),
      icon: Icons48(iconKey: expense.expenseCategory,defaultKey: "OTHER",),
      subtext: Text("[Vehicle name here]"), //todo: resolve vehicle name
      topTrailer: Text(expense.cost.toStringAsFixed(2) + "€"),//todo: prefered currency
      bottomTrailer: expense.datePaid == null ?
      Text(dateFormat(expense.datePaid), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),) :
      Text(dateFormat(expense.dateToPay), style: TextStyle(color: Colors.green),),
      onTap: null,
      deleteCallback: () => expenseBloc.markAsDeleted(expense),
      editCallback: () => Navigator.of(context).push(
        MaterialPageRoute(
            /*Todo: pass a ExpenseBloc here, if no vehicle is available (seeing all expenses) then resolve the vehicle for that expense*/
            builder: (context) => InsertExpense(editExpense: expense,)
        ),
      ),
    );
  }
}