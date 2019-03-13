import 'package:auto_size_text/auto_size_text.dart';
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
        title: Text("Statistiche"),
      ),
      body:  SingleChildScrollView(
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
                return Center(
                  child: EmptyPlaceHolder(
                    //Todo: make this expense type aware (e.g different text/icons for different expenses types)
                      image:Icons100(iconKey: "CHART",color: Colors.black45,),
                      fontSize: 20,
                      text: "Non sono ancora presenti dati"
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    AutoSizeText(
                      "Totale Spese da pagare Per Anno",
                      //minFontSize: 20,
                      maxLines: 2,
                      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 400.0,
                      height: 400.0,
                      child: Container(
                        margin: EdgeInsets.all(35),
                        child: SimpleBarChart(
                          _createChartsData(snapshot.data),
                          // Disable animations for image tests.
                          animate: true,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
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
