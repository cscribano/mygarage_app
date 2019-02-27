import 'dart:core';

class HttpException implements Exception{

  final int httpCode;
  final String error;
  HttpException({this.httpCode, this.error});

  @override
  String toString() => "Error while fetching data: $httpCode - $error";
}

class UnauthenticatedException implements Exception{
  UnauthenticatedException() : super();

  @override
  String toString() => "Exception: UnauthenticatedException";
}