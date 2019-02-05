import '../blocs/auth_bloc.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();
  BuildContext ctx;
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
                      if(snapshot.hasData){
                        if(snapshot.data == AuthState.LOGGED_OUT) {
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
                                    onPressed: () => _authBloc.doLogin("test", "test"),//null,
                                    color: Colors.blue,
                                  ),
                                  margin: EdgeInsets.only(top: 20.0),
                                ),
                              ],
                            ),
                          );
                        }
                        else{
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            Navigator.of(context).pushReplacementNamed('/Home');
                          });
                          return Container();
                        }
                      }
                      else if(snapshot.hasError){
                        return Text(snapshot.error);
                      }
                      else{
                        _authBloc.authState();
                        return CircularProgressIndicator();
                      }
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
    usernameController.dispose();
    passwordController.dispose();
    _authBloc.dispose();
    super.dispose();
  }

}
