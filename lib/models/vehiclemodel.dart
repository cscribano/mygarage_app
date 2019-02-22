// To parse this JSON data, do
//
//     final Vehicle = VehicleFromJson(jsonString);

import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'basemodel.dart';

/*
Vehicle VehicleFromJson(String str) {
  final jsonData = json.decode(str);
  return Vehicle.fromJson(jsonData);
}

String VehicleToJson(Vehicle data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}
*/

class Vehicle extends BaseModel{
  String guid;
  int isDeleted;
  String testText;
  int testNum;

  Vehicle({
    String key,
    this.guid,
    this.testText,
    this.testNum,
    this.isDeleted,
  }) : super(key: key);

  Vehicle.create({this.testText,this.testNum,}){
    var bytes = utf8.encode(Random.secure().nextDouble().toString()); // data being hashed
    var digest = sha1.convert(bytes).toString();
    this.guid = digest;
  }

  factory Vehicle.fromJson(Map<String, dynamic> json){

    int insIsDelete;
    if(json["is_deleted"].runtimeType == bool){
      insIsDelete = json["is_deleted"] ? 1 : 0;
    }
    else{
      insIsDelete = json["is_deleted"]?? 0;
    }

    var ret = Vehicle(
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
