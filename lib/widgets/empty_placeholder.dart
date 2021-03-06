import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class EmptyPlaceHolder extends StatelessWidget{
  final Icon image;
  final String text;
  final double fontSize;

  EmptyPlaceHolder({this.image, this.text, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      margin: EdgeInsets.only(top:150),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Image.asset('assets/icons/big/icons8-support-filled-100.png', color: Colors.black45,scale: 1.1,),
          image,
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          //Text('Add a New Expense', style: TextStyle(color: Colors.black45, fontSize: fontSize),),
          AutoSizeText(
            text,
            style: TextStyle(color: Colors.black45, fontSize: fontSize),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

}