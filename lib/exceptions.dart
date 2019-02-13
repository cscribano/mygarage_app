import 'dart:core';

class HttpException implements Exception{

  final int httpCode;
  HttpException({this.httpCode});

  @override
  String toString() => "Error while fetching data: $httpCode";
}

class UnauthenticatedException implements Exception{
  UnauthenticatedException() : super();

  @override
  String toString() => "Exception: UnauthenticatedException";
}