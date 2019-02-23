import 'pages/login.dart';
import 'pages/list.dart';
import 'widgets/bloc_provider.dart';
import 'blocs/vehicle_bloc.dart';
import 'translations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*
* TODO:
* Sincronizzazione DELETED (ok, non vengono ancora eliminati gli elementi marcati in locale)
* creare modello "expense" con foreign key e testare sincronizzazione.
*
* fixare crash se si preme sync tante volte in poco tempo (opzioni: singleto, rendere incliccabile finche non finisce)
* nota: fixato rendendo classe VehicleProvider singleton! (vedere utilizzi singleton, user repo??)
*
* fix: chiamando piuo volte sync si "accumulano" gli snack (prima di generare snack pop di quello esistente?)
* ok:Scaffold.of(_cxt).removeCurrentSnackBar();
*
* implement RestProvider (ok)
* finire implementazione generica sync (funzionante con diversi Model) (ok)
*/

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VehicleBloc(),
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
          primarySwatch: Colors.red,
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