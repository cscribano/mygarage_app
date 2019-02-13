import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

abstract class baseModel {
  const baseModel({this.key});
  final String key;
}