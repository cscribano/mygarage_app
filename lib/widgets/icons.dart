import 'package:flutter/material.dart';

class IconProvider extends Icon{
  final String baseIconsPath;
  final String iconKey;
  final Map<String, String> type2Pic;
  final String defaultKey;
  final Color color;

  IconProvider({Key key,
    @required this.baseIconsPath,
    @required this.iconKey,
    @required this.type2Pic,
    @required this.defaultKey,
    this.color
  }) : super(null);// : super(key:key);

  @override
  Widget build(BuildContext context) {
      if(type2Pic.containsKey(iconKey.toUpperCase())){
        return Image.asset(baseIconsPath+type2Pic[iconKey.toUpperCase()], color: color);
      }
      return Image.asset(baseIconsPath+type2Pic[defaultKey], color: color);
  }
}

class VehicleIcons48 extends IconProvider{

  static final String _baseIconsPath = "assets/icons/";

  static final Map<String, String> _type2Pic = {
    "CAR" : "icons8-fiat-500-48.png",
    "BIKE" : "icons8-motorcycle-48.png",
    "VAN" : "icons8-van-48.png",
    "RV" : "icons8-camper-48.png",
    "AGRO" : "icons8-tractor-48.png",
    "BOAT" : "icons8-sailing-ship-48.png",
    "OTHER" : "icons8-rocket-48.png",
  };

  final String iconKey;
  VehicleIcons48({@required this.iconKey}) : super(baseIconsPath: _baseIconsPath, type2Pic : _type2Pic, iconKey: iconKey, defaultKey : "OTHER");
}

class VehicleIcons24 extends IconProvider {
  static final String _baseIconsPath = "assets/icons/small/";

  static final Map<String, String> _type2Pic = {
    "CAR": "icons8-car-24.png",
    "BIKE": "icons8-motorcycle-24.png",
    "VAN": "icons8-van-24.png",
    "RV": "icons8-camper-24.png",
    "AGRO": "icons8-tractor-24.png",
    "BOAT": "icons8-sailing-ship-24.png",
    "OTHER": "icons8-rocket-24.png",
  };

  final String iconKey;
  final Color color;
  VehicleIcons24(
      {@required this.iconKey, this.color}
  ) : super(baseIconsPath: _baseIconsPath, type2Pic : _type2Pic, iconKey: iconKey, defaultKey : "OTHER", color: color);
}

class InsertVehicleIcons24 extends IconProvider {
  static final String _baseIconsPath = "assets/icons/small/";

  static final Map<String, String> _type2Pic = {
    "MANUFACTURER": "icons8-factory-24.png",
    "DATEYEAR": "icons8-calendar-24.png",
    "FUEL": "icons8-gas-pump-24.png",
    "PRICE": "icons8-price-24.png",
    "MILES": "icons8-road-24.png",
    "OTHER": "icons8-help-24.png",
  };

  final String iconKey;
  final Color color;
  InsertVehicleIcons24(
      {@required this.iconKey, this.color}
      ) : super(baseIconsPath: _baseIconsPath, type2Pic : _type2Pic, iconKey: iconKey, defaultKey : "OTHER", color: color);
}