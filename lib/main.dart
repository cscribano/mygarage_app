import 'package:mockapp_bloc/pages/login.dart';
import 'package:mockapp_bloc/pages/list.dart';
import 'widgets/bloc_provider.dart';
import 'blocs/mock_bloc.dart';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //routes: ,
        home: BlocProvider(
            child: LoginPage(),//MyHomePage(),
            bloc: MockBloc(),
        ),
    );
  }
}