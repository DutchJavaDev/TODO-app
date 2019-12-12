import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'utils/filesys.dart' as FileSys;
import 'utils/taskmanager.dart' as TaskManager;

class AppSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppSettingsStateFull();
  }
}

class AppSettingsStateFull extends StatefulWidget {
  AppSettingsState createState() => AppSettingsState();
}

class AppSettingsState extends State<AppSettingsStateFull> {
  final Color _buttonColor = Color(0xff044762);

  void _confirmDialog(Widget title, Widget content, VoidCallback action) async {
    await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title,
            content: Padding(
              padding: EdgeInsets.only(top: 15),
              child: content,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("Yes"),
                isDestructiveAction: true,
                onPressed: (){
                  action();
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _buildSettings() {
    final double taskHeaderSize = FileSys.getSettingsModel.getHeaderFontSize;
    final double taskDescriptionSize =
        FileSys.getSettingsModel.getDescriptionFontSize;

    final Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
                           Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: SizedBox(
                width: double.infinity,
                height: size.height * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 6,right: 6, top: 6, bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("WARNING!",style: TextStyle(fontSize: 23, color: Colors.red),),
                        Text("TODO add warning text here for deleting stuff",textAlign: TextAlign.left, style: TextStyle(fontSize: 18),)
                      ],
                    ),
                  ),
                ),
              ),
            ),
           Padding(
          padding: EdgeInsets.only(top: 14),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Header fontsize: (${taskHeaderSize.floor()})",
                    style: TextStyle(fontSize: 22)),
                CupertinoSlider(
                  min: 12.0,
                  max: 34.0,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      FileSys.getSettingsModel.setHeaderFontSize(newValue);
                      FileSys.saveSettings();
                    });
                  },
                  value: taskHeaderSize,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Description fontsize: (${taskDescriptionSize.floor()})",
                    style: TextStyle(fontSize: 22)),
                CupertinoSlider(
                  min: 12.0,
                  max: 42.0,
                  divisions: 10,
                  onChanged: (newValue) {
                    setState(() {
                      FileSys.getSettingsModel.setDescriptionFontSize(newValue);
                      FileSys.saveSettings();
                    });
                  },
                  value: taskDescriptionSize,
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14, left: 8, right: 8),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
            child: Text(
              "Delete all active tasks",
              style: TextStyle(
                  fontSize: 22, color: CupertinoColors.destructiveRed),
            ),
            onPressed: () {
              _confirmDialog(
                  Text(
                    "Delete active tasks",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  Text(
                    "Are you sure you want to delete all active tasks?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TaskManager.deleteActiveTasks);
            },
            color: _buttonColor,
          ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14, left: 8, right: 8),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
            child: Text(
              "Delete all completed tasks",
              style: TextStyle(
                  fontSize: 22, color: CupertinoColors.destructiveRed),
            ),
            onPressed: () {
                  _confirmDialog(
                  Text(
                    "Delete completed tasks",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  Text(
                    "Are you sure you want to delete all completed tasks?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TaskManager.deleteAllDoneTasks);
            },
            color: _buttonColor,
          ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14,left: 8, right: 8),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
            child: Text(
              "Delete all tasks",
              style: TextStyle(
                  fontSize: 22, color: CupertinoColors.destructiveRed),
            ),
            onPressed: () {
               _confirmDialog(
                  Text(
                    "Delete all tasks",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                  Text(
                    "Are you sure you want to delete all tasks?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TaskManager.deleteAll);
            },
            color: _buttonColor,
          ),
          ),
        ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Text(""),
        middle: Text("Settings",
            style: TextStyle(fontSize: 24, color: CupertinoColors.white)),
        padding: EdgeInsetsDirectional.only(bottom: 5),
        backgroundColor: CupertinoTheme.of(context).primaryColor,
      ),
      child: _buildSettings(),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.blueGrey,
    );
  }
}
