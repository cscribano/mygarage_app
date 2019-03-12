import 'pages/login.dart';
import 'pages/vehicles_list.dart';
import 'pages/insert_vehicle.dart';
import 'pages/Overview.dart';
import 'pages/expenses_list.dart';

import 'widgets/bloc_provider.dart';
import 'models/expensemodel.dart';

import 'blocs/vehicle_bloc.dart';
import 'blocs/auth_bloc.dart';
import 'blocs/expense_bloc.dart';

import 'translations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*
* TODO:
* Mettere in ExpenseBloc Vehicle non come guid ma come Model
* * aggiunta spesa/intervento
* IMPORTANTE Errori database non vengono testati da BLOCs! (e quindi la pagina carica all'infinito)
* Dividerere spese per priorità scadute -- da pagare (in ordine) -- pagate
* Aggiungere filtraggio spese per data, tipologia... (Non ordinamento, filtraggio)
* Pagina registrazione
* pagina reset password
* * ---- DONE -----
* * impostare               overflow: TextOverflow.ellipsis, dove serve (Text)
* Menu a tendina scelta visualizzazione spese per veicolo
* * Limitare lunghezza campi di testo veicolo
* * Pagina pagament/Interventi +
* * Pagina principale (overview) (mockup)
* * Pagina dettagli veicolo
* * Considerare di spostare inserisci/modifica veicolo su bloc, idem per validazione campi inserimento (va bene come è )
* * Modificare insert form per modifica veicolo esistente (initial value...)
* Expense/Payment Tile (generic tile?)
* menu a tendina long press (elimina...)
* ** Campi veri modelli vehicle, expense
* * Pagina Inserimento veicolo
* Drawer (opzione Logout, cancella....) -> Forse usare bloc_provider non è la migliore delle ide...
* markAsDeleted CASCADE su vehicle (valutare eliminazione effettiva da sqlite)  (0k, no eliminazione locale per ora
* Sincronizzazione Expense (0k)
* Probabilmente implementare generico anche per REST (no)
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
      bloc: AuthBloc(),
      child: BlocProvider(
          bloc: VehicleBloc(tag: "Main VB"),
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
              '/Home' : (context) =>  Overview(),
              '/VehicleList' : (context) => VehiclesList(),
              '/InsertVehicle' : (context) => InsertVehicle(),
              '/Repais' : (context) => BlocProvider(
                child: VehicleExpenses(drawerEntry: 3,),
                bloc: ExpenseBloc(expenseType: ExpenseEnum.WORK, tag: "Main Re"),
              ),
              '/Papers' : (context) => BlocProvider(
                child: VehicleExpenses(drawerEntry: 4,),
                bloc: ExpenseBloc(expenseType: ExpenseEnum.PAPER, tag: "Main Pa"),
              )
            } ,
            //home: LoginPage(),
            home: LoginPage(),
          ),
      )
    );
  }
}