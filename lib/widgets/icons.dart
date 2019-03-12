import 'package:flutter/material.dart';

class IconProvider extends Icon{
  final String baseIconsPath;
  final String iconKey;
  final Map<String, String> type2Pic;
  final String defaultKey;
  final Color color;
  final double scale;

  IconProvider({Key key,
    @required this.baseIconsPath,
    @required this.iconKey,
    @required this.type2Pic,
    @required this.defaultKey,
    this.scale,
    this.color
  }) : super(null);// : super(key:key);

  @override
  Widget build(BuildContext context) {
    if(type2Pic.containsKey(iconKey.toUpperCase())){
      return Image.asset(baseIconsPath+type2Pic[iconKey.toUpperCase()], color: color);
    }
    try{
      var ret = Image.asset(baseIconsPath+type2Pic[defaultKey], color: color, scale: this.scale,);
      return ret;
    }
    on Exception {
      return Icon(Icons.error);
    }
  }
}

class Icons100 extends IconProvider{

  static final String _baseIconsPath = "assets/icons/big/";

  static final Map<String, String> _type2Pic = {
    "LOGO" : "icons8-garage-96.png",
    "HELP" : "icons8-europe-96.png",
    "GARAGE" : "icons8-garage-filled-100.png",
    "VEHICLE" : "icons8-traffic-jam-filled-96.png",
    "WORK" : "icons8-maintenance-96.png",
    "PAPER" : "icons8-credit-card-96.png",
    "OTHER" : "icons8-help-48.png"
  };

  final String iconKey;
  final Color color;
  final String defaultkey;
  final double scale;
  Icons100({
    @required this.iconKey,
    this.color,
    this.defaultkey,
    this.scale,
  }) : super(
      baseIconsPath: _baseIconsPath,
      type2Pic : _type2Pic,
      iconKey: iconKey,
      defaultKey : defaultkey?? "OTHER",
      color: color,
      scale: scale,
  );
}

class Icons48 extends IconProvider{

  static final String _baseIconsPath = "assets/icons/";

  static final Map<String, String> _type2Pic = {
    //Vehicle
    "CAR" : "icons8-fiat-500-48.png",
    "BIKE" : "icons8-motorcycle-48.png",
    "VAN" : "icons8-van-48.png",
    "RV" : "icons8-camper-48.png",
    "AGRO" : "icons8-tractor-48.png",
    "BOAT" : "icons8-sailing-ship-48.png",
    "OTHER_VEHICLE" : "icons8-rocket-48.png",

    //Work
    "ENGINE"  : "icons8-engine-48.png",
    "MAINT" : "icons8-engine-oil-48.png",
    "TYRE" : "icons8-wheel-48.png",
    "BODY" : "icons8-crashed-car-48.png",
    "ELECTRIC" :"icons8-car-battery-48.png",
    "GLASS" : "car_door.png",
    "TUNING" : "icons8-turbocharger-48.png",
    "OTHER_WORK" : "icons8-maintenance-48.png",

    //Papers
    //List<String> PAPER_CAT = ["TAX", "INSURANCE", "TICKET", "PARK", "ACCIDENT", "ACCESSORY", "OTHER"];
    "TAX" : "icons8-tax-48.png",
    "INSURANCE" : "icons8-car-insurance-48.png",
    "TICKET" : "icons8-no-entry-48.png",
    "PARK" : "icons8-paid-parking-48.png",
    "ACCIDENT" : "icons8-crashed-car-48.png",
    "ACCESSORY" : "icons8-tesla-model-x-48.png",
    "OTHER_PAPER" : "icons8-bill-48.png",

    "OTHER_ANY" : "icons8-help-48.png"
  };

  final String iconKey;
  final String defaultKey;
  Icons48({
    @required this.iconKey, this.defaultKey
  }) : super(
      baseIconsPath: _baseIconsPath,
      type2Pic : _type2Pic,
      iconKey: iconKey,
      defaultKey : defaultKey?? "OTHER"
  );
}

class Icons24 extends IconProvider {
  static final String _baseIconsPath = "assets/icons/small/";

  static final Map<String, String> _type2Pic = {
    "WORK" : "icons8-support-24.png",
    "PAPER" : "icons8-credit-card-24.png",

    "CAR": "icons8-car-24.png",
    "BIKE": "icons8-motorcycle-24.png",
    "VAN": "icons8-van-24.png",
    "RV": "icons8-camper-24.png",
    "AGRO": "icons8-tractor-24.png",
    "BOAT": "icons8-sailing-ship-24.png",
    "OTHER_VEHICLE": "icons8-rocket-24.png",

    "MANUFACTURER": "icons8-factory-24.png",
    "DATEYEAR": "icons8-calendar-24.png",
    "FUEL": "icons8-gas-pump-24.png",
    "PRICE": "icons8-price-24.png",
    "MILES": "icons8-road-24.png",
    "OTHER_INSERT": "icons8-help-24.png",

    "ENGINE"  : "icons8-engine-24.png",
    "MAINT" : "icons8-engine-oil-24.png",
    "TYRE" : "icons8-wheel-24.png",
    "BODY" : "icons8-crashed-car-24.png",
    "ELECTRIC" :"icons8-car-battery-24.png",
    "GLASS" : "icons8-this-way-up-24",
    "TUNING" : "icons8-turbocharger-24.png",
    "OTHER_WORK" : "icons8-support-24.png",

    "TAX" : "icons8-bill-24.png",
    "INSURANCE" : "icons8-car-insurance-24.png",
    "TICKET" : "icons8-no-entry-24.png",
    "PARK" : "icons8-paid-parking-24.png",
    "ACCIDENT" : "icons8-crashed-car-24.png",
    "ACCESSORY" : "icons8-tesla-model-x-24.png",
    "OTHER_PAPER" : "icons8-bill-24.png",
  };

  final String iconKey;
  final Color color;
  final String defaultkey;
  Icons24({
    @required this.iconKey,
    this.color,
    this.defaultkey
  }) : super(
      baseIconsPath: _baseIconsPath,
      type2Pic : _type2Pic,
      iconKey: iconKey,
      defaultKey : defaultkey?? "OTHER",
      color: color
  );
}