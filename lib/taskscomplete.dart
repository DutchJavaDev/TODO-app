import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'utils/taskmanager.dart' as TaskManager;
import 'utils/filesys.dart' as FileSys;

class TasksCompleted extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return TasksCompletedState();
  }
}

class TasksCompletedState extends StatefulWidget
{
  @override
  TasksCompletedWidget createState() => TasksCompletedWidget(); 
}

class TasksCompletedWidget extends State<TasksCompletedState>
{

  double screenWidth;
  double screenHeight;

  @override
  void initState()
  {
    super.initState();
  }

  void deleteAll() async
  {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)
      {
        return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            content: Container(
              width: screenWidth,
              height: 125,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Text(
                      "Are you sure you want to delete all the tasks?"),
                  Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              TaskManager.deleteAllDoneTasks();
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Yes"),
                          color: Colors.greenAccent,
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"),
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
      }
    );
  }

  void deleteTask(String id) async {
    var task = TaskManager.getTaskById(id);
    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            content: Container(
              width: screenWidth,
              height: 125,
              color: Colors.transparent,
              child: Column(
                children: <Widget>[
                  Text(
                      "Are you sure you want to delete item '${task.taskTitle}'?"),
                  Padding(
                    padding: EdgeInsets.only(top: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            setState(() {
                              TaskManager.deleteTask(task.taskId);
                              Navigator.pop(context);
                            });
                          },
                          child: Text("Yes"),
                          color: Colors.greenAccent,
                        ),
                        RaisedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("No"),
                          color: Colors.redAccent,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  /// Creates the views for the tasks, adds a delete and edit button
  List<Widget> createViewAndroid() {
    var items = List<Widget>();
    int counter = 0;
    for (var task in TaskManager.completedTask) {
      var headerText = Text("${task.taskTitle}",
          style: TextStyle(
              fontSize: 28,
              color: Colors.black54,
              fontWeight: FontWeight.bold));
      var description = Text("${task.taskDescription}",
          style: TextStyle(fontSize: 20, color: Colors.black54));

      var headerDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FileSys.getSettingsModel.taskHeaderColor);
      var header = Container(
        child: Center(
          child: headerText,
        ),
        width: screenWidth,
        height: 50,
        decoration: headerDecoration,
      );

      var buttonBar = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            child: Icon(
              FontAwesomeIcons.check,
              color: Colors.greenAccent,
              size: 24,
            ),
            onPressed: () {
              
            },
          ),
          RaisedButton(
            child: Icon(
              FontAwesomeIcons.solidEdit,
              color: Colors.blue[300],
              size: 24,
            ),
            onPressed: () {
              
            },
          ),
        ],
      );

      var column = Column(
        children: <Widget>[
          Padding(
            child: header,
            padding: EdgeInsets.only(bottom: 0, top: 0),
          ),
          Padding(
            child: description,
            padding: EdgeInsets.only(bottom: 20, left: 25, right: 25, top: 35),
          ),
          Padding(
            child: buttonBar,
            padding: EdgeInsets.only(bottom: 15, top: 5),
          )
        ],
      );

      var itemDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: task.taskColor);
      var container = Container(
        child: column,
        width: screenWidth,
        decoration: itemDecoration,
      );

      items.add(Padding(
        child: container,
        padding: EdgeInsets.only(
            bottom: 5, top: counter == 0 ? 5 : 0, left: 5, right: 5),
      ));

      counter++;
    }

    if (items.length == 0) {
      items.add(Padding(
        child: Center(
          child: Text(
            "Empty list",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 24, color: Colors.white),
          ),
        ),
        padding: EdgeInsets.only(top: screenHeight / 2.5),
      ));
    }
    return items;
  }

  List<Widget> createViewIOS(){
    var items = List<Widget>();
    int counter = 0;
    for (var task in TaskManager.completedTask) {
      var headerText = Text("${task.taskTitle}",
          style: TextStyle(
              fontSize: 28,
              color: Colors.black54,
              fontWeight: FontWeight.bold));
      var description = Text("${task.taskDescription}",
          style: TextStyle(fontSize: 20, color: Colors.black54));

      var headerDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: FileSys.getSettingsModel.taskHeaderColor);
      var header = Container(
        child: Center(
          child: headerText,
        ),
        width: screenWidth,
        height: 50,
        decoration: headerDecoration,
      );

      var buttonBar = Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              Icons.replay,
              color: CupertinoColors.activeGreen,
              size: 28,
            ),
            onPressed: () {
              TaskManager.flipTaskStatus(task.taskId);
              setState(() {
                
              });
            },
            color: Color(0xff054961),
          ),
          CupertinoButton(
            child: Icon(
              CupertinoIcons.delete_solid,
              color: CupertinoColors.destructiveRed,
              size: 28,
            ),
            color: Color(0xff054961),
            onPressed: () {
              // TODO create confirm dialog for ios
              TaskManager.deleteTask(task.taskId);
              setState(() {
                
              });
            },
          ),
        ],
      );

      var column = Column(
        children: <Widget>[
          Padding(
            child: header,
            padding: EdgeInsets.only(bottom: 0, top: 0),
          ),
          Padding(
            child: description,
            padding: EdgeInsets.only(bottom: 20, left: 25, right: 25, top: 35),
          ),
          Padding(
            child: buttonBar,
            padding: EdgeInsets.only(bottom: 15, top: 5),
          )
        ],
      );

      var itemDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: task.taskColor);
      var container = Container(
        child: column,
        width: screenWidth,
        decoration: itemDecoration,
      );

      items.add(Padding(
        child: container,
        padding: EdgeInsets.only(
            bottom: 5, top: counter == 0 ? 5 : 0, left: 5, right: 5),
      ));

      counter++;
    }

    if (items.length == 0) {
      items.add(Padding(
        child: Center(
          child: Text(
            "Empty list",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 24, color: Colors.white),
          ),
        ),
        padding: EdgeInsets.only(top: screenHeight / 2.5),
      ));
    }
    return items;
  }


  Widget getScaffold()
  {
    if(Platform.isAndroid)
    {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Completed tasks",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        width: screenWidth * 0.6,
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
              onPressed: (){},
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 32,
              ),
            ),
            FlatButton(
              onPressed: (){},
              child: Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: createViewAndroid(),
        controller: ScrollController(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
    }
    else if(Platform.isIOS)
    {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          trailing: GestureDetector(
            onTap: showSettings,
            child: Icon(CupertinoIcons.settings,size: 38, color: CupertinoColors.white,)
          ),
          middle: Text("Completed tasks",style: TextStyle(fontSize: 24,color: CupertinoColors.white)),
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(CupertinoIcons.back,size: 38,color: CupertinoColors.white,),
          ),
          padding: EdgeInsetsDirectional.only(bottom: 5),
          automaticallyImplyLeading: true,
          automaticallyImplyMiddle: true,
          transitionBetweenRoutes: true,
          backgroundColor: CupertinoTheme.of(context).primaryColor,
        ),
        child: ListView(
          children: createViewIOS(),
          controller: ScrollController(),
        ),
        backgroundColor: Colors.blueGrey,
      );
    }

    return Container(child: Center(child: Text("Platform not yet supported"),),);
  }

    /// Opens settings
  void showSettings() async{
    if(Platform.isAndroid)
    {
      /// TODO android?
    }
    else if (Platform.isIOS)
    {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context)
        {
          return CupertinoActionSheet(
            title: Text("App settings"), 
            actions: <Widget>[
              CupertinoButton(
                onPressed: (){

                  var currentList = TaskManager.completedTask;

                  for(var i = 0; i < currentList.length; i++)
                  {
                    TaskManager.flipTaskStatus(currentList[i].taskId);
                  }
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Text("Restore all task's",style: TextStyle(fontSize: 22),),
              ),
              CupertinoButton(
                onPressed: () async{
                  // Temp fix, need to universal ui or seperarte ui for deleting all task
                  var currentList = TaskManager.completedTask;

                  for(var i = 0; i < currentList.length; i++)
                  {
                    TaskManager.deleteTask(currentList[i].taskId);
                  }
                  setState(() {
                    
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Delete all task's",style: TextStyle(fontSize: 22,color: CupertinoColors.destructiveRed),),
              )
            ],
            cancelButton: CupertinoButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ), 
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return getScaffold();
  }
}