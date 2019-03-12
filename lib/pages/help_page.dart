import 'package:flutter/material.dart';
import 'package:mygarage/translations.dart';
import 'package:mygarage/widgets/default_drawer.dart';
import 'package:mygarage/widgets/empty_placeholder.dart';
import 'package:mygarage/widgets/icons.dart';

class Help extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _HelpState();
}

class _HelpState extends State<Help>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).text('help_title')),
      ),
      body: Center(
        child: EmptyPlaceHolder(
          image: Icons100(iconKey: "HELP", scale: 1.1,),
          text: "Made on Earth by Humans",
          fontSize: 20,
        ),
      ),
      drawer:DefaultDrawer(highlitedVoice: 6,),
    );
  }

}