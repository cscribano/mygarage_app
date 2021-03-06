import 'dart:convert';
import 'package:flutter/foundation.dart';

class BaseModel {
  BaseModel({this.guid});
  String guid;

  factory BaseModel.fromJson(Map<String, dynamic> json) => BaseModel();
  Map<String, dynamic> toJson({@required int dirty}) => Map<String, String>();
}