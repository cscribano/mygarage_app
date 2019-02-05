import 'package:mockapp_bloc/pages/login.dart';
import 'package:mockapp_bloc/pages/list.dart';
import 'widgets/bloc_provider.dart';
import 'blocs/mock_bloc.dart';

import 'package:flutter/material.dart';

/*
* TODO:
* - Completare meccanismo di logi (salvataggio delle credenziali),
* - Completare meccanismo di sincronizzazone
* */

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: MockBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/Login' : (context) => LoginPage(),
          '/Home' : (context) => MyHomePage()
        } ,
        home: LoginPage(),
      ),
    );
  }
}