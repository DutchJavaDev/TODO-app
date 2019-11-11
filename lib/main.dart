import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_build/complete.dart';
import 'addorupdate.dart';
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

  void addTask() {
    Navigator.push(context,animatedEditRoute());
  }

  Route animatedEditRoute({String id = "null"}) {
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

  Route animatedSettingRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CompletedTask(),
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

  void showSettings() async {
    Navigator.push(context, animatedSettingRoute());
    // await showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return Dialog(
    //         backgroundColor: Theme.of(context).backgroundColor,
    //         shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.all(Radius.circular(12))),
    //         child: Container(
    //           width: screenWidth,
    //           height: screenHeight * 0.17,
    //           child: Padding(
    //             padding:
    //                 EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
    //             child: ListView(
    //               controller: ScrollController(),
    //               children: <Widget>[
    //                 RaisedButton(
    //                   onPressed: () {
    //                     TaskManager.deleteAll();
    //                     setState(() {
    //                       Navigator.of(context).pop();
    //                     });
    //                   },
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                     children: <Widget>[
    //                       Text(
    //                         "Delete all tasks 0",
    //                         style: TextStyle(
    //                             fontSize: 24,
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       Icon(
    //                         FontAwesomeIcons.solidTrashAlt,
    //                         size: 28,
    //                         color: Colors.black,
    //                       ),
    //                     ],
    //                   ),
    //                   color: Color(0xffe53935),
    //                 ),
    //                 Padding(
    //                   padding: EdgeInsets.only(top: 10),
    //                   child: MaterialButton(
    //                     onPressed: () => Navigator.of(context).pop(),
    //                     child: Text(
    //                       "Close",
    //                       style: TextStyle(fontSize: 24, color: Colors.white),
    //                     ),
    //                     color: Theme.of(context).buttonColor,
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }

  void editTask(String id) {
    Navigator.of(context).push(animatedEditRoute(id: id));
  }

  void doneTask(String id) {
    var model = TaskManager.getTaskById(id);
    model.taskDone = true;
    TaskManager.updateTask(model);
    setState(() {});
  }


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
              doneTask(task.taskId);
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
                FontAwesomeIcons.cog,
                color: Colors.white,
                size: 28,
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
