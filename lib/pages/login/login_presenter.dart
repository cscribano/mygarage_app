import '../../data/rest_data.dart';
import '../../models/user.dart';

abstract class LoginViewContract{
  void onLoadLoginComplete(User user);
  void onLoadLoginError(String error);
}

class LoginPresenter{
  LoginViewContract _view;
  RestData api = RestData();

  LoginPresenter(this._view);

  doLogin(String username, String password){

    api.getToken(username, password)
        .then((user) => _view.onLoadLoginComplete(user))
        .catchError((onError) => _view.onLoadLoginError(onError.toString()));
  }
}