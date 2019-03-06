import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'basemodel.dart';

List<String> VEHICLE_CAT = ["CAR", "BIKE", "VAN", "RV", "AGRO", "BOAT","OTHER"];
List<String> FUEL_CAT = ["GAS", "DIESEL", "EV", "LPG", "METHANE", "OTHER"];

class Vehicle extends BaseModel{
  String type;
  String brand;
  String model;
  String fuel;
  int currentOdo;
  double buyPrice;
  int modelYear;

  int isDeleted;

  Vehicle({
    String guid,
    this.type,
    this.brand,
    this.model,
    this.fuel,
    this.currentOdo,
    this.buyPrice,
    this.modelYear,
    this.isDeleted,
  }) : super(guid: guid);

  Vehicle.create({
    this.type,
    this.brand,
    this.model,
    this.fuel,
    this.currentOdo,
    this.buyPrice,
    this.modelYear,}){

      var bytes = utf8.encode(Random.secure().nextDouble().toString()); // data being hashed
      var digest = sha1.convert(bytes).toString();
      this.guid = digest;
      this.isDeleted = 0;
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
        type: json["type"],
        brand: json["brand"],
        model: json["model"],
        fuel: json["fuel"],
        currentOdo: json["current_odo"],
        buyPrice: json["buy_price"] != null ? json["buy_price"].toDouble() : null,
        modelYear: json["model_year"],
        isDeleted: insIsDelete
      //dirty??
    );
    return ret;
  }

  Map<String, dynamic> toJson({@required int dirty}) => {
    "guid": guid,
    "type": type,
    "brand": brand,
    "model": model,
    "fuel": fuel,
    "current_odo": currentOdo,
    "buy_price": buyPrice,
    "model_year": modelYear,
    "is_deleted": isDeleted
  };

  Map<String, dynamic> toJson_API({@required int rev}) => {
    "guid": guid,
    "type": type,
    "brand": brand,
    "model": model,
    "fuel": fuel,
    "current_odo": currentOdo != null ? currentOdo.toString() : null,
    "buy_price": buyPrice != null ? buyPrice.toString() : null,
    "model_year": modelYear != null ? buyPrice.toString() : null,
    "rev_sync": rev.toString(),
    "is_deleted": isDeleted.toString(),
  };
}
