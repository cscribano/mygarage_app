import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'basemodel.dart';

class Expense extends BaseModel{
  String guid;
  String vehicle;
  int isDeleted;
  String innerText;
  int innerNum;

  Expense({
    String key,
    this.guid,
    this.vehicle,
    this.innerText,
    this.innerNum,
    this.isDeleted,
  }) : super(key: key);

  Expense.create({this.vehicle, this.innerText,this.innerNum,}){
    var bytes = utf8.encode(Random.secure().nextDouble().toString()); // data being hashed
    var digest = sha1.convert(bytes).toString();
    this.guid = digest;
    this.isDeleted = 0;
  }

  @override
  factory Expense.fromJson(Map<String, dynamic> json){

    int insIsDelete;
    if(json["is_deleted"].runtimeType == bool){
      insIsDelete = json["is_deleted"] ? 1 : 0;
    }
    else{
      insIsDelete = json["is_deleted"]?? 0;
    }

    var ret = Expense(
        guid: json["guid"],
        vehicle: json["vehicle"],
        innerText: json["test_text"],
        innerNum: json["test_num"],
        isDeleted: insIsDelete
      //dirty??
    );
    return ret;
  }

  @override
  Map<String, dynamic> toJson({@required int dirty}) => {
    "guid": guid,
    "vehicle" : vehicle,
    "inner_text": innerText,
    "inner_num": innerNum,
    "is_dirty": dirty,
    "is_deleted": isDeleted
  };

  Map<String, dynamic> toJson_API({@required int rev}) => {
    "guid": guid,
    "vehicle" : vehicle,
    "test_text": innerText,
    "test_num": innerNum.toString(),
    "rev_sync": rev.toString(),
    "is_deleted": isDeleted.toString()
  };
}
