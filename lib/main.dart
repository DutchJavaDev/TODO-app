import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_build/taskscomplete.dart';
import 'package:test_build/updatetasklist.dart';
import 'updatetasklist.dart';
import 'utils/filesys.dart' as FileSys;
import 'utils/taskmanager.dart' as TaskManager;

void main() async {
  await FileSys.initFileSystem();
  await TaskManager.initManager();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO list',
      theme: ThemeData(
        primaryColor: Color(0xff054961),
        buttonColor: Color(0xff054961),
        backgroundColor: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double screenWidth;
  double screenHeight;

  @override
  void initState() {
    super.initState();
  }

  /// Opens the updateview with an id of null 
  void addTask() {
    Navigator.push(context,animatedUpdateRoute());
  }

  /// Simple animation for switching to the update/add task view
  Route animatedUpdateRoute({String id = "null"}) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => UpdateTaskList(
              taskId: id,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0, 1);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  /// Simple animation for switching to the completed task view
  Route animatedCompletedTaskRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => TasksCompleted(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0, 1);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  /// Opens settings
  void showSettings() {
    Navigator.push(context, animatedCompletedTaskRoute());
  }

  /// Opens the updateview with the given task id
  void editTask(String id) {
    Navigator.push(context,animatedUpdateRoute(id: id));
  }

  /// Updates the given task to done
  void setTaskToDone(String id) {
    TaskManager.flipTaskStatus(id);
    setState(() {});
  }

  /// Creates the views for the tasks, adds a delete and edit button
  List<Widget> createView() {
    var items = List<Widget>();
    int counter = 0;
    for (var task in TaskManager.openTasks) {
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
              setTaskToDone(task.taskId);
            },
          ),
                  RaisedButton(
            child: Icon(
              FontAwesomeIcons.solidEdit,
              color: Colors.blue[300],
              size: 24,
            ),
            onPressed: () {
              editTask(task.taskId);
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
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
              onPressed: () {
                showSettings();
              },
              child: Icon(
                Icons.settings,
                color: Colors.white,
                size: 32,
              ),
            ),
            FlatButton(
              onPressed: addTask,
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
        children: createView(),
        controller: ScrollController(),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
