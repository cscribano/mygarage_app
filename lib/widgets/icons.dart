import 'package:flutter/material.dart';

class VehicleIcons48 extends StatelessWidget{

  static final String baseIconsPath = "assets/icons/";

  static final Map<String, String> _type2Pic = {
    "CAR" : "icons8-fiat-500-48.png",
    "BIKE" : "icons8-motorcycle-48.png",
    "VAN" : "icons8-van-48.png",
    "RV" : "icons8-camper-48.png",
    "AGRO" : "icons8-tractor-48.png",
    "BOAT" : "icons8-sailing-ship-48.png",
    "OTHER" : "icons8-rocket-48.png",
  };

  final String vehicleType;
  VehicleIcons48({this.vehicleType});

  @override
  Widget build(BuildContext context) {
    if(_type2Pic.containsKey(vehicleType.toUpperCase())){
      return Image.asset(baseIconsPath+_type2Pic[vehicleType.toUpperCase()]);
    }
    return Image.asset(baseIconsPath+_type2Pic["OTHER"]);
  }
}

class VehicleIcons24 extends StatelessWidget{
  static final String baseIconsPath = "assets/icons/small/";

  static final Map<String, String> _type2Pic = {
    "CAR" : "icons8-car-24.png",
    "BIKE" : "icons8-motorcycle-24.png",
    "VAN" : "icons8-van-24.png",
    "RV" : "icons8-van-24.png",
    "AGRO" : "icons8-tractor-24.png",
    "BOAT" : "icons8-sailing-ship-24.png",
    "OTHER" : "icons8-rocket-24.png",
  };

  final String vehicleType;
  VehicleIcons24({this.vehicleType});

  @override
  Widget build(BuildContext context) {
    if(_type2Pic.containsKey(vehicleType.toUpperCase())){
      return Image.asset(baseIconsPath+_type2Pic[vehicleType.toUpperCase()], color: IconTheme.of(context).color);
    }
    return Image.asset(baseIconsPath+_type2Pic["OTHER"], color: IconTheme.of(context).color);
  }
}