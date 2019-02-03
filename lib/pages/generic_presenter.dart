import '../data/rest_data.dart';
import '../data/database_helper.dart';

abstract class GenericViewContract<T>{
  void onLoadFetchComplete(T ret);
  void onLoadFetchError(String error);
}

abstract class AuthViewContract<T> extends GenericViewContract<T>{
  Map<String,String> getAuth();
}

class BasePresenter<T>{

  GenericViewContract<T> _view;
  BasePresenter(this._view);

  RestData api = RestData();
  DBProvider db = DBProvider();

  GenericViewContract<T> get view => this._view;

  fetchData(Future<dynamic> dataSource){
    dataSource
        .then((list) => _view.onLoadFetchComplete(list))
        .catchError((onError) => _view.onLoadFetchError(onError.toString()));
  }
}

class BaseAuthPresenter<T>{

  AuthViewContract<T> _view;
  BaseAuthPresenter(this._view);

  RestData api = RestData();
  DBProvider db = DBProvider();

  AuthViewContract<T> get view => this._view;

  fetchData(Future<dynamic> dataSource){
    dataSource
        .then((list) => _view.onLoadFetchComplete(list))
        .catchError((onError) => _view.onLoadFetchError(onError.toString()));
  }
}
