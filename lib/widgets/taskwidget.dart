import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_build/models/models.dart';
import 'package:test_build/utils/filesys.dart' as FileSys;

class TaskView extends StatelessWidget
{
  final SettingsModel _settings = FileSys.getSettingsModel;

  final TaskModel task;

  final ValueChanged<int> leftAction;
  final Icon leftActionIcon;

  final ValueChanged<int> rightAction;
  final Icon rightActionIcon;

  final Color _buttonColor = Color(0xff044762);

  TaskView({this.task, @required this.leftAction, @required this.leftActionIcon, @required this.rightAction, @required this.rightActionIcon});

  BoxDecoration _taskDecoration()
  {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: task.taskColor
    );
  }

  BoxDecoration _headerDecoration()
  {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: FileSys.getSettingsModel.taskHeaderColor
    );
  }

  Widget _taskHeader()
  {
    return SizedBox(
      width: double.infinity,
      child: Container(
        height: 50,
        child: Center(child: Text(task.taskTitle, style: TextStyle(fontSize: _settings.getHeaderFontSize),),),
        decoration: _headerDecoration(),
      ),
    );
  }

  Widget _taskDescription()
  {
    return Text(task.taskDescription, style: TextStyle(fontSize: _settings.getDescriptionFontSize),);
  }

  Widget _taskActions()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CupertinoButton(
          child: leftActionIcon,
          onPressed: () => leftAction(task.taskId),
          color: _buttonColor
        ),
        CupertinoButton(
          child: rightActionIcon,
          onPressed: () => rightAction(task.taskId),
          color: _buttonColor
        )
      ],
    );
  }

  Widget build(BuildContext context)
  {
    return Padding(
      padding: EdgeInsets.only(left: 6,right: 6, top: 12),
      child: SizedBox(
      child: Container(
        decoration: _taskDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
           Padding(
             padding: EdgeInsets.only(),
             child: _taskHeader(),
           ),
           Padding(
             padding: EdgeInsets.only(bottom: 20, left: 25, right: 25, top: 35),
             child: _taskDescription(),
           ),
           Padding(
             padding: EdgeInsets.only(bottom: 15, top: 5),
             child: _taskActions(),
           )
          ],
        ),
      ),
    ),
    );
  }
}