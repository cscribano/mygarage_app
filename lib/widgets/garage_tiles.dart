import 'package:mygarage/translations.dart';

import 'package:flutter/material.dart';

String capitalize(String s) => s != "" ? s[0].toUpperCase() + s.substring(1) : "[Missing text]"; //Unsafe in string is empty
String dateFormat(DateTime d){
  return d != null ? d.day.toString() + "/" + d.month.toString() + "/" + d.year.toString() : "";
}


class MyGarageTile extends StatelessWidget{

  //final Vehicle vehicle;
  final Icon icon;
  final Text text;
  final Text subtext;
  final Text topTrailer;
  final Text bottomTrailer;
  final void Function() onTap;
  final void Function() deleteCallback;
  final void Function() editCallback;
  MyGarageTile({
    @required this.text,
    @required this.subtext,
    @required this.icon,
    this.topTrailer,
    this.bottomTrailer,
    this.onTap,
    this.deleteCallback,
    this.editCallback,
  });

  var _tapPosition;
  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _showActionsMenu(BuildContext context){
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    showMenu(
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size   // Bigger rect, the entire screen
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: () =>_showDeleteDialog(context),
          child: Text(Translations.of(context).text('tile_menu_delete')),
        ),
        PopupMenuItem(
          value: editCallback,
          child: Text(Translations.of(context).text('tile_menu_Edit')),//this._index,
        )
      ],
      context: context,
    ).then((value) => value());
  }

  void _showDeleteDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Translations.of(context).text('delete_alert_title')),
            content: Text(Translations.of(context).text('delete_alert_body')),
            actions: <Widget>[
              FlatButton(
                child: Text(Translations.of(context).text('delete_alert_no')),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text(Translations.of(context).text('delete_alert_yes')),
                onPressed: (){
                  deleteCallback();
                  Navigator.of(context).pop();
                },//null,//() => Navigator.of(_cxt).pushReplacementNamed("/Login"),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTapDown: _storePosition,
      onTap: onTap,
      onLongPress: () => _showActionsMenu(context),

      child: Card(
        margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 5, right: 5),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                text,
                subtext
              ],
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.yellow[300],
              child: Container(margin: EdgeInsets.all(5.0),child: icon,),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                topTrailer,
                bottomTrailer,
              ].where((widget) => widget != null).toList(),
            ),
          ),
        ),
      ),
    );
  }
}