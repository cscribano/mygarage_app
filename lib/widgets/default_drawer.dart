import 'package:flutter/material.dart';
import 'package:mygarage/blocs/auth_bloc.dart';
import 'package:mygarage/translations.dart';
import 'bloc_provider.dart';

class DefaultDrawer extends StatefulWidget{
  final int highlitedVoice;
  DefaultDrawer({this.highlitedVoice});

  @override
  State<StatefulWidget> createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer>{

  void pushIfCan({@required BuildContext context, @required int curent, @required String route}){
    Navigator.of(context).pop();
    if(widget.highlitedVoice != curent )
      Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    String _translation(String text) => Translations.of(context).text(text);
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.authState();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white70,
              foregroundColor: Colors.red[800],
              child: Text('A', style: TextStyle(fontSize: 25),),
            ),
            accountName: Text(_translation('drawer_user_anonymous'),style: TextStyle(fontSize: 20),),
            accountEmail: Text(_translation('drawer_user_unlogged')),
            margin: EdgeInsets.only(bottom: 5),
          ),

          //Overview
          ListTile(
            selected: widget.highlitedVoice == 1,
            title: Text(_translation('drawer_entry_overview')),
            leading: Icon(Icons.view_quilt,),
            onTap: () =>  this.pushIfCan(context: context, curent: 1, route: '/Home')
          ),

          //Garage
          ListTile(
            selected: widget.highlitedVoice == 2,
            title: Text(_translation('drawer_entry_vehicles')),
            leading: Icon(Icons.directions_car),
            onTap: () =>  this.pushIfCan(context: context, curent: 2, route: '/VehicleList')
          ),

          //Garage
          ListTile(
            selected: widget.highlitedVoice == 3,
            title: Text(_translation('drawer_entry_repairs')),
            leading: Icon(Icons.build),
            onTap: () =>  this.pushIfCan(context: context, curent: 3, route: '/Repais')
          ),

          //Payments
          ListTile(
            selected: widget.highlitedVoice == 4,
            title: Text(_translation('drawer_entries_payments')),
            leading: Icon(Icons.payment),
              onTap: () =>  this.pushIfCan(context: context, curent: 4, route: '/Papers')
          ),

          //Stats
          ListTile(
            selected: widget.highlitedVoice == 5,
            title: Text(_translation('drawer_entry_stats')),
            leading: Icon(Icons.pie_chart),
            onTap:null,
          ),

          Divider(),

          //Stats
          ListTile(
            selected: widget.highlitedVoice == 6,
            title: Text(_translation('drawer_entry_help')),
            leading: Icon(Icons.help),
            onTap:null,
          ),

          //Login/Logout
          StreamBuilder(
            stream: authBloc.outStream,
            builder: (context, AsyncSnapshot<AuthState> snapshot) {
              if(snapshot.hasData && snapshot.data == AuthState.LOGGED_IN) {
                return LogoutTile();
              }
              return LoginTile();
            },
          ),
        ],
      ),
    );
  }
}

class LogoutTile extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(Translations.of(context).text('drawer_entry_logout')),
      leading: Icon(Icons.exit_to_app),
      onTap: () => _logutDialog(context),
    );
  }

  void _logutDialog(BuildContext context) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(Translations.of(context).text('logout_alert_title')),
          content: Text(Translations.of(context).text('logout_alert_body')),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(Translations.of(context).text('logout_alert_no')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(Translations.of(context).text('logout_alert_yes')),
              onPressed: () {
                authBloc.doLogout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class LoginTile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(Translations.of(context).text('drawer_entry_login')),
      leading: Icon(Icons.exit_to_app),
      onTap: () => Navigator.of(context).pushReplacementNamed("/Login"),
    );
  }
}