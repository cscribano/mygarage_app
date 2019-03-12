import 'package:mygarage/widgets/empty_placeholder.dart';
import 'package:mygarage/widgets/icons.dart';

import '../widgets/bloc_provider.dart';
import '../widgets/default_drawer.dart';
import '../widgets/sync_widgets.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/vehicle_bloc.dart';

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
          SyncButton(
            //thenCallback: ...,
          ),
        ],
      ),
      body: Center(
        child: EmptyPlaceHolder(
          image: Icons100(iconKey: "LOGO", scale: 1,),
          text: Translations.of(context).text('home_placeholder'),
          fontSize: 20,
        ),
      ),
      drawer:DefaultDrawer(highlitedVoice: 1,),
    );
  }

}
