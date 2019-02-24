import '../blocs/vehicle_bloc.dart';
import '../blocs/expense_bloc.dart';
import '../models/vehiclemodel.dart';
import '../widgets/bloc_provider.dart';
import '../widgets/sync_widgets.dart';
import '../translations.dart';
import 'expenses_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context) {

    final VehicleBloc vehicleBloc = BlocProvider.of<VehicleBloc>(context);
    final scaffoldKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(Translations.of(context).text('home_title')),
        actions: <Widget>[
          SyncButton(),
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: vehicleBloc.outVehicle,//bloc.allVehicles,
            builder: (context, AsyncSnapshot<List<Vehicle>> snapshot){
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if (!snapshot.hasData){
                vehicleBloc.getVehicles();
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Vehicle item = snapshot.data[index];
                  return ListTile(
                    title: Text(item.testText),
                    leading: Text(item.testNum.toString()),
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => vehicleBloc.deleteVehicle(item.guid),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BlocProvider(bloc: ExpenseBloc(vehicle: item.guid), child: VehicleExpenses(),),
                          ),
                      );
                    }
                  );
                },
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
          onPressed: vehicleBloc.addRandom,
      ),
    );
  }

}