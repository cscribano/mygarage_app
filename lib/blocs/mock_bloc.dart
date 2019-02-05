import '../data/auth_repository.dart';
import '../models/mockupmodel.dart';
import '../widgets/bloc_provider.dart';
import '../data/database_helper.dart';

import 'dart:async';

class MockBloc implements BlocBase{

  StreamController<List<Mock>> _mockController = StreamController<List<Mock>>.broadcast();
  Sink<List<Mock>> get _inMock => _mockController.sink;
  Stream<List<Mock>> get outMock => _mockController.stream;

  final DBProvider _db = DBProvider();

  MockBloc(){
    getMocks();
  }

  void getMocks() async{
    _inMock.add(await _db.getAllMocks());
  }

  void addMock(Mock newMock){
    _db.insertMock(newMock);
    getMocks();
  }

  void addRandom(){
    _db.insertRandom();
    getMocks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _mockController.close();
  }

}