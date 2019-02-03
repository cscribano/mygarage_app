import '../../models/mockupmodel.dart';
import 'list_presenter.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements ListViewContract {
  
  ListPresenter _listPresenter;
  
  _MyHomePageState(){
    _listPresenter = ListPresenter(this);
  }

  @override
  void onLoadFetchComplete(List<Mock> ret) {
    // TODO: implement onLoadFetchComplete
    print(ret);
  }

  @override
  void onLoadFetchError(String error) {
    // TODO: implement onLoadFetchError
    print(error);
  }

  @override
  Map<String, String> getAuth() {
    return {'Authorization': 'Token 3992f5f862c53239ee0339673f9c31928ee2f0d7'};
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter SQLite")),
      body: FutureBuilder<List<Mock>>(
        future: _listPresenter.getList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Mock item = snapshot.data[index];
                return ListTile(
                  title: Text(item.testText),
                  leading: Text(item.testNum.toString()),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
  
}