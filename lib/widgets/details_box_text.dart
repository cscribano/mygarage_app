import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DetailsBoxText extends StatelessWidget{

  final String heading;
  final String text;
  final maxLines;

  DetailsBoxText({this.heading, this.text, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(heading, style: TextStyle(fontWeight: FontWeight.w400),),
          //Text(text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
          AutoSizeText(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),
            maxLines: maxLines?? 1,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

class MyVerticalDivider extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 30.0,
      width: 0.5,
      color: Colors.black45,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }

}