import 'pages/login.dart';
import 'pages/list.dart';
import 'widgets/bloc_provider.dart';
import 'blocs/vehicle_bloc.dart';
import 'translations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*
* TODO:
* markAsDeleted CASCADE su vehicle (valutare eliminazione effettiva da sqlite)
*
* Sincronizzazione Expense (0k)
* Probabilmente implementare generico anche per REST (no)
* ----
* Evitare ri-sincronizzazione di elementi "deleted" ma non "dirty" (il problema è che la funzione getAllDirty restituisce anche i deleted,
* altrimenti questi non verrebbero sincronizzati). Soluzioni: eliminazione client-side (fare come gestire con modello foreign key?)
* non considerare più i deleted come dirty (in questo modo possiamo fare safe-delete).
* OK: il metodo markAsDeleted imposta is_dirty = 1, il medoto getAllDirty restituisce SOLO i dirty (NO is_deleted = 1)
*
* Implementare visualizzazione/aggiunta di EXPENSE per ogni VEHICLE (ok)
*
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