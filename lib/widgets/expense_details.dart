import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
import 'package:mygarage/widgets/details_box_text.dart';
import 'package:mygarage/widgets/garage_tiles.dart';

import '../blocs/expense_bloc.dart';
import '../models/vehiclemodel.dart';
import '../models/expensemodel.dart';
import '../pages/expenses_list.dart';
import '../widgets/bloc_provider.dart';

class ExpenseDetails extends StatefulWidget{
  final Expense expense;
  ExpenseDetails({Key key, @required this.expense}) : super(key:key);

  @override
  State<StatefulWidget> createState() => _ExpenseDetailsState();

}

class _ExpenseDetailsState extends State<ExpenseDetails>{
  @override
  Widget build(BuildContext context) {
    Translations translation = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('home_title')),
/*        actions: <Widget>[
          SyncButton(),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              children: <Widget>[
                ExpenseDetailsBox(expense: widget.expense,),
              ],
            )
        ),
      ),
      //drawer: BlocProvider(bloc: AuthBloc(), child: DefaultDrawer(highlitedVoice: 1,),),
    );
  }
}


//String _capitalize(String s) => s != "" ? s[0].toUpperCase() + s.substring(1) : "[Missing text]";

class ExpenseDetailsBox extends StatelessWidget{
  final Expense expense;
  ExpenseDetailsBox({Key key, @required this.expense}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final expenseTypeToString = ExpenseTypeToString(context);
    final expenseTypeEnum = ExpenseTypeToEnum[expense.expenseType];

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
      margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            // padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            child: Text(
              expense.details,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child:DetailsBoxText(heading: "Type of Expense",text: expenseTypeToString[expenseTypeEnum],),
              ),
              //MyVerticalDivider(),
              Expanded(
                child: DetailsBoxText(
                    heading: "Category of Expense",
                    text: ExpenseCategoryToString(context, expenseTypeEnum)[expense.expenseCategory]
                ),
              ),
            ],
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DetailsBoxText(heading: "Price",text: expense.cost != null ? expense.cost.toStringAsFixed(2) : '-',),
              //MyVerticalDivider(),
              DetailsBoxText(heading: "Pay Until",text: expense.cost != null ? dateFormat(expense.dateToPay) : '-'),
            ],
          ),
          Divider(color: Colors.black45,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DetailsBoxText(heading: "Payid On",text: expense.datePaid != null ? dateFormat(expense.datePaid) : '-',),
              //MyVerticalDivider(),
            ],
          ),
          Divider(color: Colors.black45,),
        ],
      ),
    );
  }

}