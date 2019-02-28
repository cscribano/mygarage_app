import 'package:flutter/material.dart';
import 'package:mygarage/blocs/auth_bloc.dart';
import 'bloc_provider.dart';

class DefaultDrawer extends StatefulWidget{
  final int highlitedVoice;
  DefaultDrawer({this.highlitedVoice});

  @override
  State<StatefulWidget> createState() => _DefaultDrawerState();
}

class _DefaultDrawerState extends State<DefaultDrawer>{

  @override
  Widget build(BuildContext context) {
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
            accountName: Text("Anonymus",style: TextStyle(fontSize: 20),),
            accountEmail: Text("You are currently not logged in"),
            margin: EdgeInsets.only(bottom: 5),
          ),

          //Overview
          ListTile(
            selected: widget.highlitedVoice == 1,
            title: Text("Overview"),
            leading: Icon(Icons.view_quilt,),
            onTap:null,
          ),

          //Garage
          ListTile(
            selected: widget.highlitedVoice == 2,
            title: Text("Vehicles"),
            leading: Icon(Icons.directions_car),
            onTap:null,
          ),

          //Garage
          ListTile(
            selected: widget.highlitedVoice == 3,
            title: Text("Repairs"),
            leading: Icon(Icons.build),
            onTap:null,
          ),

          //Payments
          ListTile(
            selected: widget.highlitedVoice == 4,
            title: Text("Payments"),
            leading: Icon(Icons.payment),
            onTap:null,
          ),

          //Stats
          ListTile(
            selected: widget.highlitedVoice == 5,
            title: Text("Graphs"),
            leading: Icon(Icons.pie_chart),
            onTap:null,
          ),

          Divider(),

          //Stats
          ListTile(
            selected: widget.highlitedVoice == 6,
            title: Text("Help"),
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
      title: Text("Logout"),
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
          title: Text("Logout"),
          content: Text("Are you sure to log out?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("YES"),
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
      title: Text("Login"),
      leading: Icon(Icons.exit_to_app),
      onTap: () => Navigator.of(context).pushReplacementNamed("/Login"),
    );
  }
}