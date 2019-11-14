import 'package:flutter/material.dart';
import '../utils/filesys.dart' as FileSys;

import 'package:test_build/models/models.dart';

class ColorEdit extends StatelessWidget
{
  Widget build(BuildContext context)
  {
    return ColorEditState();
  }
}

class ColorEditState extends StatefulWidget
{
  @override
  ColorEditWidget createState() => ColorEditWidget();
}

class ColorEditWidget extends State<ColorEditState>
{

  SettingsModel settings;

  @override
  initState() {
    super.initState();
    settings = FileSys.getSettingsModel;
  }

    List<Widget> createEditView()
  {
    var items = List<Widget>();

    for(var color in settings.getBackgroundColors)
    {
      var row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
            width: MediaQuery.of(context).size.width*0.3,
            height: 38,
            color: color
          ),
          ),
          RaisedButton(
            // Atleast one color should be there otherwise the 'updatetasklist' crashes in initState
            onPressed: settings.getBackgroundColors.length == 1 ? null : (){
              setState(() {
                settings.removeColor(color);
                FileSys.saveSettings();
                settings = FileSys.getSettingsModel;
              });
            },
            child: Text("Delete",style: TextStyle(color: Colors.white,fontSize: 20),),
          )
        ],
      );

      items.add(Padding(
        padding: EdgeInsets.only(top: 2.5,bottom: 5),
        child: row,
      ));
    }

    return items;
  }

  Widget build(BuildContext context) {
    return AlertDialog(
          title: Center(child: Text("Edit Colors",style: TextStyle(fontSize: 24,color: Colors.white),),),
          backgroundColor: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          content: SingleChildScrollView(
            child: Column(
              children: createEditView(),
            ),
          ),
          actions: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              child: RaisedButton(
                color: Colors.red,
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Close",style: TextStyle(color: Colors.white, fontSize: 24),),
              ),
            )
          ],
        );;
  }
}
