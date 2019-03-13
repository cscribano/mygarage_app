import 'package:mygarage/blocs/expense_bloc.dart';
import 'package:mygarage/models/expensemodel.dart';
import 'package:mygarage/widgets/empty_placeholder.dart';
import 'package:mygarage/widgets/icons.dart';

import '../widgets/bloc_provider.dart';
import '../widgets/default_drawer.dart';

import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class ExpenseStats extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _ExpenseStatsState();
}

class _ExpenseStatsState extends State<ExpenseStats>{

 // int _selectedYear;
  Translations translation;

  @override
  Widget build(BuildContext context) {
    translation = Translations.of(context);

    final expenseBloc = BlocProvider.of<ExpenseBloc>(context);

    //final Future<List<int>> yearsList = ExpenseProvider().getToPayYears();
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('home_title')),
      ),
      body:  StreamBuilder(
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
                  image:Icons100(iconKey: eeToString(expenseBloc.expenseType),color: Colors.black45,),
                  fontSize: 20,
                  text: translation.text("empty_expense_type_${eeToString(expenseBloc.expenseType)}")
              );
            }
            return Container(
                margin: EdgeInsets.all(50),
                child: SimpleBarChart(
                  _createChartsData(snapshot.data),
                  // Disable animations for image tests.
                  animate: false,
                ),
            );
          }
      ),
      drawer:DefaultDrawer(highlitedVoice: 5,),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<Expense, String>> _createChartsData(List<Expense> data) {

    return [
      new charts.Series<Expense, String>(
        id: 'Expense',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Expense e, _) => e.dateToPay.year.toString(),
        measureFn: (Expense e, _) => e.cost?? 0,
        data: data,
      )
    ];
  }

}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }
}
