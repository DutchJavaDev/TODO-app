import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'utils/taskmanager.dart' as TaskManager;
import 'widgets/taskwidget.dart';

class TasksCompleted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TasksCompletedState();
  }
}

class TasksCompletedState extends StatefulWidget {
  @override
  TasksCompletedWidget createState() => TasksCompletedWidget();
}

class TasksCompletedWidget extends State<TasksCompletedState> {
  double screenWidth;
  double screenHeight;

  @override
  void initState() {
    super.initState();
  }

  void _deleteTaskDialog(String id) async {
    var task = TaskManager.getTaskById(id);

    await showCupertinoDialog(
      context: context,
      builder: (BuildContext context)
      {
        return CupertinoAlertDialog(

          title: Text("Delete task ${task.taskTitle}?", style: TextStyle(color: Colors.red),),
          content: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text("Are you sure you want to delete this task?", style: TextStyle(fontSize: 18),),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Yes delete", style: TextStyle(fontWeight: FontWeight.bold),),
              isDestructiveAction: true,
              onPressed: (){
                TaskManager.deleteTask(id);
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("No keep"),
              isDefaultAction: true,
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  List<Widget> createView() {
    var items = List<Widget>();

    for (var task in TaskManager.completedTask) {
      items.add(TaskView(
        task: task,
        leftAction: (taskId){
          TaskManager.flipTaskStatus(taskId);
          setState(() {
            
          });
        },
        leftActionIcon: Icon(
          FontAwesomeIcons.redo,
          color: Colors.greenAccent,
          size: 24,
          ),

        rightAction: (taskId){
          _deleteTaskDialog(taskId);
          setState(() {
            
          });
        },
        rightActionIcon: Icon(
          FontAwesomeIcons.trash, 
          color: CupertinoColors.destructiveRed,
          size: 24,
          ),
      ));
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
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Completed tasks",
            style: TextStyle(fontSize: 24, color: CupertinoColors.white)),
        padding: EdgeInsetsDirectional.only(bottom: 5),
        automaticallyImplyLeading: true,
        automaticallyImplyMiddle: true,
        transitionBetweenRoutes: true,
        backgroundColor: CupertinoTheme.of(context).primaryColor,
      ),
      child: ListView(
        children: createView(),
        controller: ScrollController(),
      ),
      backgroundColor: Colors.blueGrey,
    );
  }
}
