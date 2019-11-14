import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  SettingsModel settings;
  String titleError;
  String descriptionError;
  Color taskColor;
  bool isEnabled = false;

  final hightLight = Colors.yellowAccent;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    /// Listen for changes in the input
    titleController.addListener(titleListener);
    descriptionController.addListener(descriptionListener);
    settings = FileSys.getSettingsModel;

    if (!(widget.taskId == "null")) {
      model = TaskManager.getTaskById(widget.taskId);
      titleController.text = model.taskTitle;
      descriptionController.text = model.taskDescription;
      taskColor = model.taskColor;
    } else {
      titleController.text = "";
      descriptionController.text = "";
      taskColor = settings.getBackgroundColors[0];
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
      taskColor = settings.getBackgroundColors[index];
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
            onPressed: (){
              // Bug, cant refresh the alertdialog
              settings.removeColor(color);
              if(taskColor == color)
              {
                taskColor = settings.getBackgroundColors.first;
              }
              setState(() {
                
              });
              // Temp fix
              Navigator.of(context).pop();

              // To fix this i need to put the alertdialog in its own statefullwidget so i can refresh it
              // when i delete a color
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

  void editColors() async
  {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context)
      {
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
        );
      }
    );
  }

  void addNewColor() async {
    var color = settings.taskHeaderColor;

    await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("Pick a color",style: TextStyle(fontSize: 24,color: Colors.white),),),
            backgroundColor: Theme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            content: SingleChildScrollView(
              child: ColorPicker(
                onColorChanged: (newColor) {
                  color = newColor;
                },
                pickerColor: color,
                enableAlpha: true,
                enableLabel: true,
                pickerAreaHeightPercent: 0.8,
                paletteType: PaletteType.hsl,
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.red,
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  settings.addColor(color);
                  FileSys.saveSettings();
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                child: Text(
                  "Add color",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              )
            ],
          );
        });
  }

  List<Widget> createColorGrid() {
    var colors = List<Widget>();
    var backgroundColors = settings.getBackgroundColors;

    for (var i = 0; i < backgroundColors.length; i++) {
      colors.add(Container(
        child: Padding(
          child: RaisedButton(
            onPressed: () => setColor(i),
            color: backgroundColors[i],
          ),
          padding: EdgeInsets.only(left: 5, right: 5),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: taskColor == backgroundColors[i]
                ? hightLight
                : Colors.transparent),
      ));
    }

    /// max 12 colors
    if(backgroundColors.length != 12)
    {
      colors.add(RaisedButton(
        onPressed: addNewColor,
        color: Theme.of(context).buttonColor,
        child: Icon(
          FontAwesomeIcons.plusCircle,
          size: 24,
          color: Colors.white,
        ),
      ));
    }

    colors.add(RaisedButton(
      onPressed: editColors,
      child: Icon(Icons.settings,size: 28,color: Colors.white,),
    ));
    return colors;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.taskId == "null" ? "Add task" : "Edit: ${titleController.text}"}",
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                child: GridView.count(
                  crossAxisCount: 4,
                  children: createColorGrid(),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3,
                  shrinkWrap: true,
                ),
                padding: EdgeInsets.only(top: 25, bottom: 45),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
