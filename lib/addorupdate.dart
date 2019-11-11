import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/models.dart';
import 'utils/taskmanager.dart' as TaskManager;
import 'utils/filesys.dart' as FileSys;

class UpdateTaskList extends StatelessWidget {
  final String taskId;

  UpdateTaskList({this.taskId = "null"});

  @override
  Widget build(BuildContext context) {
    return UpdateTaskListStateFull(
      taskId: taskId,
    );
  }
}

class UpdateTaskListStateFull extends StatefulWidget {
  final String taskId;

  UpdateTaskListStateFull({Key key, this.taskId = "null"}) : super(key: key);

  @override
  UpdateTaskListState createState() => UpdateTaskListState();
}

class UpdateTaskListState extends State<UpdateTaskListStateFull> {
  TaskModel model;
  String titleError;
  String descriptionError;
  Color taskColor;
  bool isEnabled = false;

  final hightLight = Color(0xffffd600);
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Listen for changes in the input
    titleController.addListener(titleListener);
    descriptionController.addListener(descriptionListener);

    if (!(widget.taskId == "null")) {
      model = TaskManager.getTaskById(widget.taskId);
      titleController.text = model.taskTitle;
      descriptionController.text = model.taskDescription;
      taskColor = model.taskColor;
    } else {
      titleController.text = "";
      descriptionController.text = "";
      taskColor = FileSys.getSettingsModel.backgroundColors[0];
    }
    titleError = "";
    descriptionError = "";
  }

  void titleListener() {
    var title = titleController.text;
    setState(() {
      if (title == null || title == "") {
        titleError = "Title can't be empty";
      } else {
        titleError = "";
      }

      isEnabled = canSave();
    });
  }

  void descriptionListener() {
    var description = descriptionController.text;
    setState(() {
      if (description == null || description == "") {
        descriptionError = "Description can't be empty";
      } else {
        descriptionError = "";
      }

      isEnabled = canSave();
    });
  }

  void dispose() {
    super.dispose();
    titleController.removeListener(titleListener);
    descriptionController.removeListener(descriptionListener);

    titleController.dispose();
    descriptionController.dispose();
  }

  void setColor(int index) {
    setState(() {
      taskColor = FileSys.getSettingsModel.backgroundColors[index];
    });
  }

  bool canSave() {
    return titleController.text.length > 0 &&
        descriptionController.text.length > 0;
  }

  bool submitTask() {
    if (model != null) {
      model.taskTitle = titleController.text;
      model.taskDescription = descriptionController.text;
      model.taskColor = taskColor;
      TaskManager.updateTask(model);
      return true;
    } else {
      TaskManager.addTaskWithColor(
          titleController.text, descriptionController.text, taskColor);
      return true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.taskId == "null" ? "Add task" : "Edit: ${titleController.text}"}",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Padding(
          child: ListView(
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelText: "Task title",
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                Text(
                  titleError,
                  style: TextStyle(
                      color: Color(0xffff5252),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )
              ]),
              Column(
                children: <Widget>[
                  Padding(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: descriptionController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Description",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      maxLines: 10,
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                  ),
                  Text(descriptionError,
                      style: TextStyle(
                          color: Color(0xffff5252),
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                ],
              ),
              Padding(
                child: Column(
                  children: <Widget>[
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(0),
                          color: FileSys.getSettingsModel.backgroundColors[0],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[0]
                                  ? hightLight
                                  : Colors.transparent),
                    ),
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(1),
                          color: FileSys.getSettingsModel.backgroundColors[1],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[1]
                                  ? hightLight
                                  : Colors.transparent),
                    ),
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(2),
                          color: FileSys.getSettingsModel.backgroundColors[2],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[2]
                                  ? hightLight
                                  : Colors.transparent),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(3),
                          color: FileSys.getSettingsModel.backgroundColors[3],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[3]
                                  ? hightLight
                                  : Colors.transparent),
                    ),
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(4),
                          color: FileSys.getSettingsModel.backgroundColors[4],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[4]
                                  ? hightLight
                                  : Colors.transparent),
                    ),
                    Container(
                      child: Padding(
                        child: RaisedButton(
                          onPressed: () => setColor(5),
                          color: FileSys.getSettingsModel.backgroundColors[5],
                        ),
                        padding: EdgeInsets.only(left: 5, right: 5),
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color:
                              taskColor == FileSys.getSettingsModel.backgroundColors[5]
                                  ? hightLight
                                  : Colors.transparent),
                    )
                  ],
                )
                  ],
                ),
                padding: EdgeInsets.only(top: 25, bottom: 45),
              ),
              Padding(
                child: MaterialButton(
                  child: Text(
                    "${(isEnabled ? "Save" : "Waiting...")}",
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  color: Theme.of(context).buttonColor,
                  onPressed: isEnabled
                      ? () {
                          if (submitTask()) {
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  height: 64,
                ),
                padding: EdgeInsets.only(top: 15),
              )
            ],
          ),
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
