// To parse this JSON data, do
//
//     final mock = mockFromJson(jsonString);

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/*
Mock mockFromJson(String str) {
  final jsonData = json.decode(str);
  return Mock.fromJson(jsonData);
}

String mockToJson(Mock data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
*/

class Mock {
  String guid;
  int isDeleted;
  String testText;
  int testNum;

  Mock({
    this.guid,
    this.testText,
    this.testNum,
    this.isDeleted,
  });

  Mock.create({this.testText,this.testNum,}){
    var bytes = utf8.encode(Random.secure().nextDouble().toString()); // data being hashed
    var digest = sha1.convert(bytes).toString();
    this.guid = digest;
  }

  factory Mock.fromJson(Map<String, dynamic> json){

    int insIsDelete;
    if(json["is_deleted"].runtimeType == bool){
      insIsDelete = json["is_deleted"] ? 1 : 0;
    }
    else{
      insIsDelete = json["is_deleted"]?? 0;
    }

    var ret = Mock(
        guid: json["guid"],
        testText: json["test_text"],
        testNum: json["test_num"],
        isDeleted: insIsDelete
      //dirty??
    );
    return ret;
  }

  Map<String, dynamic> toJson({@required int dirty}) => {
    "guid": guid,
    "test_text": testText,
    "test_num": testNum,
    "is_dirty": dirty,
    "is_deleted": isDeleted
  };

  Map<String, dynamic> toJson_API({@required int rev}) => {
    "guid": guid,
    "test_text": testText,
    "test_num": testNum.toString(),
    "rev_sync": rev.toString(),
    "is_deleted": isDeleted.toString()
  };
}
