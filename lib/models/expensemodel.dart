import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'basemodel.dart';

import 'package:mygarage/translations.dart';
import 'package:flutter/material.dart';

String DateFormat(DateTime date){
  return date != null ? (date.year.toString()+"-"+date.month.toString()+"-"+date.day.toString()) : null;
}

String eeToString(ExpenseEnum e) => e.toString().split('.').last;

enum ExpenseEnum {PAPER, WORK, ANY}

/*List<String> WORK_CAT = ["ENGINE", "MAINT","TYRE", "BODY", "ELECTRIC", "GLASS", "TUNING","OTHER"];
List<String> PAPER_CAT = ["TAX", "INSURANCE", "TICKET", "PARK", "ACCIDENT", "ACCESSORY", "OTHER"];
List<String> EXPENSE_CAT = []..addAll(WORK_CAT)..addAll(PAPER_CAT)..toSet().toList(); //remove duplicates (?)*/

Map<ExpenseEnum, List<String>> ExpenseCategories = {
  ExpenseEnum.WORK : ["ENGINE", "MAINT","TYRE", "BODY", "ELECTRIC", "GLASS", "TUNING","OTHER"],
  ExpenseEnum.PAPER : ["TAX", "INSURANCE", "TICKET", "PARK", "ACCIDENT", "ACCESSORY", "OTHER"],
};

Map<String,String> ExpenseCategoryToString(BuildContext context, ExpenseEnum type){
  return Map.fromIterable(
    ExpenseCategories[type],
    key: (v) => v,
    value: (v) => Translations.of(context).text('expense_category_'+v),
  );
}

Map<ExpenseEnum, String> ExpenseTypeToString (BuildContext context) =>  Map.fromIterable(
  ExpenseEnum.values,
  key: (v) => v,
  value: (v) => Translations.of(context).text('expense_type_'+eeToString(v))
);

Map<String,ExpenseEnum> ExpenseTypeToEnum = Map.fromIterable(
  ExpenseEnum.values,
  key: (v) => eeToString(v),
  value: (v) => v,
);


class Expense extends BaseModel{

  String vehicle;
  String expenseType;
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
    this.expenseType, //["PAPER", "WORK"]
    this.details,
    this.datePaid,
    this.dateToPay,
    this.cost,
    this.paid,
    this.isDeleted,
  }) : super(guid : guid);

  Expense.create({
    this.vehicle,
    //this.expenseType,
    ExpenseEnum expenseType,
    this.expenseCategory,
    this.details,
    this.datePaid,
    this.dateToPay,
    this.cost,
    this.paid,}){

      var bytes = utf8.encode(Random.secure().nextDouble().toString()); // data being hashed
      var digest = sha1.convert(bytes).toString();
      this.guid = digest;
      this.expenseType = eeToString(expenseType);
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
        expenseType: json["expense_type"],
        expenseCategory: json["expense_category"],
        details: json["details"],
        datePaid: json["date_paid"] != null ? DateTime.tryParse(json["date_paid"]) : null,
        dateToPay: json["date_to_pay"] != null ? DateTime.tryParse(json["date_to_pay"]) : null,
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
    "expense_type" : expenseType,
    "expense_category": expenseCategory,
    "details": details,
    "date_paid": datePaid != null? datePaid.toIso8601String() : null,
    "date_to_pay": dateToPay != null ? dateToPay.toIso8601String() : null,
    "cost": cost,
    "paid": paid,
    "is_dirty": dirty,
    "is_deleted": isDeleted
  };

  Map<String, dynamic> toJson_API({@required int rev}) => {
    "guid": guid,
    "vehicle" : vehicle,
    "expense_type" : expenseType, //warning changed class to type
    "expense_category": expenseCategory,
    "details": details,
    "date_paid": DateFormat(datePaid),
    "date_to_pay": DateFormat(dateToPay),
    "cost": cost.toString(),
    "paid": paid != null ? paid.toString() : null,
    "rev_sync": rev.toString(),
    "is_deleted": isDeleted.toString()
  };
}
