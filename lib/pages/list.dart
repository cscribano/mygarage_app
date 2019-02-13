import '../models/mockupmodel.dart';
import '../blocs/mock_bloc.dart';
import '../widgets/bloc_provider.dart';
import '../widgets/sync_widgets.dart';
import '../translations.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context) {

    final MockBloc mockBloc = BlocProvider.of<MockBloc>(context);
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
            stream: mockBloc.outMock,//bloc.allMocks,
            builder: (context, AsyncSnapshot<List<Mock>> snapshot){
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if (!snapshot.hasData){
                mockBloc.getMocks();
                return CircularProgressIndicator();
              }
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Mock item = snapshot.data[index];
                  return ListTile(
                    title: Text(item.testText),
                    leading: Text(item.testNum.toString()),
                  );
                },
              );
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
          onPressed: mockBloc.addRandom,
      ),
    );
  }

}