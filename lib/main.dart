import 'package:mockapp_bloc/pages/login.dart';
import 'package:mockapp_bloc/pages/list.dart';
import 'widgets/bloc_provider.dart';
import 'blocs/mock_bloc.dart';
import 'translations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*
* TODO:
* Sincronizzazione DELETED
* Gestione internazionalizzazione
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: MockBloc(),
      child: MaterialApp(
        localizationsDelegates: [
          const TranslationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('it', 'IT'), // Italiano
        ],
        title:'Flutter Demo',
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