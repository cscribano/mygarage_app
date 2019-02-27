import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'basemodel.dart';

String DateFormat(DateTime date){
  return (date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString());
}

class Expense extends BaseModel{

  String vehicle;
  String expenseClass;
  String expenseCategory;
  String details;
  DateTime datePaid;
  DateTime dateToPay;
  double cost;
  double paid;
  int isDeleted;

  Expense({
    String guid,
    this.vehicle ,
    this.expenseCategory,
    this.expenseClass,
    this.details,
    this.datePaid,
    this.dateToPay,
    this.cost,
    this.paid,
    this.isDeleted,
  }) : super(guid : guid);

  Expense.create({
    this.vehicle,
    this.expenseClass,
    this.expenseCategory,
    this.details,
    this.datePaid,
    this.dateToPay,
    this.cost,
    this.paid,}){

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
        expenseClass: json["expense_class"],
        expenseCategory: json["expense_category"],
        details: json["details"],
        datePaid: DateTime.parse(json["date_paid"]),
        dateToPay: DateTime.parse(json["date_to_pay"]),
        cost: json["cost"],
        paid: json["paid"],
        isDeleted: insIsDelete
      //dirty??
    );
    return ret;
  }

  @override
  Map<String, dynamic> toJson({@required int dirty}) => {
    "guid": guid,
    "vehicle" : vehicle,
    "expense_class" : expenseClass,
    "expense_category": expenseCategory,
    "details": details,
    "date_paid": datePaid.toIso8601String(),
    "date_to_pay": dateToPay.toIso8601String(),
    "cost": cost,
    "paid": paid,
    "is_dirty": dirty,
    "is_deleted": isDeleted
  };

  Map<String, dynamic> toJson_API({@required int rev}) => {
    "guid": guid,
    "vehicle" : vehicle,
    "expense_class" : expenseClass,
    "expense_category": expenseCategory,
    "details": details,
    "date_paid": DateFormat(datePaid),
    "date_to_pay": DateFormat(dateToPay),
    "cost": cost.toString(),
    "paid": paid.toString(),
    "rev_sync": rev.toString(),
    "is_deleted": isDeleted.toString()
  };
}
