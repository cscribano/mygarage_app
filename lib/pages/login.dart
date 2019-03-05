import '../translations.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/bloc_provider.dart';

import 'package:flutter/material.dart';


class LoginForm extends StatefulWidget {

  LoginForm({Key key,}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{

  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {

    var translation = Translations.of(context);
    final _authBloc = BlocProvider.of<AuthBloc>(context);
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          //Username field
          TextFormField(
              //controller: usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: translation.text('username_hint'),
                  labelText: translation.text('username_text')
              ),
            validator: null,
            onSaved: (val) => _username = val,
          ),

          //text field
          TextFormField(
              //controller: passwordController,
              obscureText: true, // Use secure text for passwords.
              decoration: InputDecoration(
                  hintText: translation.text('password_hint'),
                  labelText: translation.text('password_text')
              ),
            validator: null,
            onSaved: (val) => _password = val,
          ),

          //Login Button
          Container(
            //padding: EdgeInsets.only(top: 50.0),
            child: RaisedButton(
              child: Text(
                translation.text('login_btn'),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  _authBloc.doLogin(_username, _password);//null,
                }
              },
              color: Colors.red,
            ),
            margin: EdgeInsets.only(top: 20.0),
          ),

          //Continue without login
          RaisedButton(
            child: Text(translation.text('skip_login_btn')),
            onPressed: () {
              Navigator.of(context).canPop() ? Navigator.of(context).pop() : Navigator.of(context).pushReplacementNamed('/Home');
            },
          ),

          //Dont' have an account....
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child:  Text(translation.text('no_account_text'),
                      style:  TextStyle(color: Color(0xFF2E3233))),
                  onTap: () {},
                ),
                GestureDetector(
                    onTap: (){},
                    child:  Text(
                      translation.text('register_gesture'),
                      style:  TextStyle(
                          color: Color(0xFF84A2AF), fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    var translation = Translations.of(context);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(translation.text('login_title')),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FlutterLogo(size: 64.0,colors: Colors.brown,),
              Flexible(
                child: StreamBuilder<AuthState>(
                  stream: _authBloc.outStream,
                  builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot){

                    //Data is present in the stream
                    if(snapshot.hasData){
                      //LOGGED_IN
                      if(snapshot.data == AuthState.LOGGED_IN) {
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          //Go to home if logged in
                          Navigator.of(context).canPop() ? Navigator.of(context).pop() : Navigator.of(context).pushReplacementNamed('/Home');
                          return CircularProgressIndicator();
                        });
                      }
                      //LOGGED OUT
                      else if(snapshot.data == AuthState.LOGGED_OUT) { //ERROR
                        return BlocProvider(bloc: _authBloc, child: LoginForm(),);
                      }
                      else if(snapshot.data == AuthState.ERROR){
                        WidgetsBinding.instance.addPostFrameCallback((_){
                          //display error message if ERROR
                          Scaffold.of(context).removeCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(translation.text('login_fail_snack')),
                              backgroundColor: Colors.red[800],
                            ),
                          );
                        });
                        return BlocProvider(bloc: _authBloc, child: LoginForm(),);
                      }
                    }
                    //error is present in the stream
                    else if(snapshot.hasError){
                      return Text(snapshot.error);
                    }
                    //Data is not present in the stream
/*                    else{
                      _authBloc.authState();
                    }*/
                    //None of the previous returned
                    return CircularProgressIndicator();
                    //none of the previous returned
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
