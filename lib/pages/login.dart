import '../models/user.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlutterLogo(size: 64.0,),
              Flexible(
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.emailAddress,
                          // Use email input type for emails.
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
                        child: RaisedButton(
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => null,//_presenter.doLogin(usernameController.text, passwordController.text),
                          color: Colors.blue,
                        ),
                        margin: EdgeInsets.only(top: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
