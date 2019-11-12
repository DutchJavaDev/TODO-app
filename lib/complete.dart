import 'package:flutter/material.dart';
import 'utils/taskmanager.dart' as TaskManager;
import 'utils/filesys.dart' as FileSys;

class CompletedTask extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return CompletedTaskState();
  }
}

class CompletedTaskState extends StatefulWidget
{
  @override
  CompleteTaskStateWidget createState() => CompleteTaskStateWidget(); 
}

class CompleteTaskStateWidget extends State<CompletedTaskState>
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

  List<Widget> createView() {
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
              Icons.replay,
              color: Colors.greenAccent,
              size: 32,
            ),
            onPressed: () {
              TaskManager.flipTaskStatus(task.taskId);
              setState(() {});
            },
          ),
          RaisedButton(
            child: Icon(
              Icons.delete_forever,
              color: Colors.redAccent,
              size: 32,
            ),
            onPressed: () {
              deleteTask(task.taskId);
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


  @override
  Widget build(BuildContext context)
  {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    int taskLenght = TaskManager.completedTaskLenght;

    return Scaffold(
      appBar: AppBar(
        title: Text("Completed tasks"),
      ),
      body: ListView(
        children: createView(),
        controller: ScrollController(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        width: screenWidth * 0.6,
        height: 45,
        child: RaisedButton(
          onPressed: taskLenght > 0 ? deleteAll : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(taskLenght > 0 ? "Delete all" : "Nothing to delete",style: TextStyle(fontSize: 28,color: taskLenght > 0 ? Colors.redAccent : Colors.white),)
            ],
          ),
        )
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}