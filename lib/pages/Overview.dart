import '../widgets/bloc_provider.dart';
import '../widgets/default_drawer.dart';
import '../widgets/sync_widgets.dart';
import '../blocs/auth_bloc.dart';

import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';

class Overview extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _OverviewState();
}

class _OverviewState extends State<Overview>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('home_title')),
        actions: <Widget>[
          SyncButton(),
        ],
      ),
      body: Center(
        child: Text("Overview page...."),
      ),
      drawer: BlocProvider(bloc: AuthBloc(), child: DefaultDrawer(highlitedVoice: 1,),),
    );
  }

}