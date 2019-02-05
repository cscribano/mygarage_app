import '../blocs/auth_bloc.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class LoginForm extends StatefulWidget {
  final AuthBloc authBloc;

  LoginForm({
    Key key,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  AuthBloc get _authBloc => widget.authBloc;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: <Widget>[
          TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'you@example.com',
                  labelText: 'E-mail Address')),
          TextFormField(
              controller: passwordController,
              obscureText: true, // Use secure text for passwords.
              decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password')),
          Container(
            //padding: EdgeInsets.only(top: 50.0),
            child: RaisedButton(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _authBloc.doLogin(usernameController.text, passwordController.text),//null,
              color: Colors.blue,
            ),
            margin: EdgeInsets.only(top: 20.0),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

class _LoginPageState extends State<LoginPage>{


  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                FlutterLogo(size: 64.0,),
                Flexible(
                  child: StreamBuilder<AuthState>(
                    stream: _authBloc.outStream,
                    builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot){

                      //Data is present in the stream
                      if(snapshot.hasData){
                        //LOGGED_IN
                        if(snapshot.data == AuthState.LOGGED_IN) {
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            Navigator.of(context).pushReplacementNamed('/Home');
                          });
                        }
                        //ERROR
                        else if(snapshot.data == AuthState.ERROR){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login failed, please retry."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        }
                      }
                      //error is present in the stream
                      else if(snapshot.hasError){
                        return Text(snapshot.error);
                      }
                      //Data is not present in the stream
                      else{
                        _authBloc.authState();
                        return CircularProgressIndicator();
                      }
                      //none of the previous returned
                      return LoginForm(
                        authBloc: _authBloc,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

}
