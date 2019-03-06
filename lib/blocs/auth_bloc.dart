import '../widgets/bloc_provider.dart';
import '../data/auth_provider.dart';

import 'dart:async';

enum AuthState{ LOGGED_IN, LOGGED_OUT,ERROR }

class AuthBloc implements BlocBase {

  //Authentication state Sink
  StreamController<AuthState> _authStream = StreamController<AuthState>.broadcast();
  Sink<AuthState> get _inSink => _authStream.sink;
  Stream<AuthState> get outStream => _authStream.stream;


  UserRepository _repo = UserRepository();

  AuthBloc(){
    authState();
  }

  authState() async {
    try {
      var ret = await _repo.getToken();
      print(ret);
      _inSink.add(AuthState.LOGGED_IN);
    }
    on Exception catch(error){
      print("Auth BLoC: "+error.toString());
      _inSink.add(AuthState.LOGGED_OUT);
    }
  }

  doLogin(String username, String password) async {
    try {
      var token = await _repo.authenticate(username, password);
      print(token);
      _repo.persistToken(token);
      authState();
    }
    catch(error){
      print("Errore login: " + error.toString());
      _inSink.add(AuthState.ERROR);
    }
  }

  doLogout() async {
    //logout from server.....
    var ret =_repo.deleteToken();
    authState();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    await _authStream.stream.drain();
    _authStream.close();
  }
}