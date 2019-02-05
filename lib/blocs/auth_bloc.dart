import 'package:mockapp_bloc/widgets/bloc_provider.dart';
import '../data/auth_repository.dart';

import 'dart:async';

enum AuthState{ LOGGED_IN, LOGGED_OUT }

class AuthBloc implements BlocBase {
  StreamController<AuthState> _authStream = StreamController<AuthState>.broadcast();
  Sink<AuthState> get _inSink => _authStream.sink;
  Stream<AuthState> get outStream => _authStream.stream;

  UserRepository _repo = UserRepository();

  AuthBloc(){
    authState();
  }

  authState() async {
    var ret =  await _repo.hasToken();

    if(ret == true){
      _inSink.add(AuthState.LOGGED_IN);
    }
    _inSink.add(AuthState.LOGGED_OUT);
  }

  doLogin(String username, String password){
    _repo.authenticate(username, password);
    //authState();
    _inSink.add(AuthState.LOGGED_IN);
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}