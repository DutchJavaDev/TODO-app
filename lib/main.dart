import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test_build/account.dart';
import 'package:test_build/api/identity.dart';
import 'package:test_build/appsettings.dart';
import 'package:test_build/taskscomplete.dart';
import 'package:test_build/updatetasklist.dart';
import 'package:test_build/widgets/taskwidget.dart';
import 'updatetasklist.dart';
import 'utils/filesys.dart' as FileSys;
import 'utils/taskmanager.dart' as TaskManager;
import 'api/apiservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FileSys.initFileSystem();

  ApiService.initService();

  // Remove before building release mode
  IdentityService.initDevMode();

  await TaskManager.initManager();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'TODO list',
      theme: CupertinoThemeData(
        primaryColor: Color(0xff054961),
        scaffoldBackgroundColor: Color(0xff054961),
        textTheme: CupertinoTextThemeData(primaryColor: CupertinoColors.white),
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
  CupertinoTabController _cupertinoTabController;

  @override
  void initState() {
    super.initState();
    _cupertinoTabController = CupertinoTabController(initialIndex: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _cupertinoTabController.dispose();
  }

  /// Updates the given task to done
  void _setTaskToDone(String id) {
    TaskManager.flipTaskStatus(id);
    setState(() {});
  }

  /// Creates the views for the tasks, adds a delete and edit button
  List<Widget> createView() {
    var items = List<Widget>();
    for (var task in TaskManager.openTasks) {

      items.add(TaskView(
        leftAction: (taskId) {
          _setTaskToDone(taskId);
        },
        leftActionIcon: Icon(
          FontAwesomeIcons.check,
          color: Colors.greenAccent,
          size: 24,
        ),
        rightAction: (taskId) {
          _editTaskPopUp(id: taskId);
        },
        rightActionIcon: Icon(
          FontAwesomeIcons.edit,
          color: Colors.blue[300],
          size: 24,
        ),
        task: task,
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

  Widget _home() {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title,
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

  void _editTaskPopUp({String id = ""}) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskList(
            taskId: id,
          );
        });

    setState(() {});
  }

  void _updateTaskPopUp() async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskList();
        });
    setState(() {});
  }

  void _accountPopUp() async
  {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context)
      {
        return AccountPanel();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return CupertinoTabScaffold(
      controller: _cupertinoTabController,
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.cloud,
              size: 32,
              )
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 36,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.checkDouble,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.tasks,
              size: 32,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 30,
            ),
          )
        ],
        backgroundColor: CupertinoTheme.of(context).primaryColor,
        currentIndex: 2,
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
        onTap: (index) {
          if(index == 0)
          {
            _accountPopUp();
            _cupertinoTabController.index = 3;
          }

          if (index == 4) {
            _updateTaskPopUp();
            _cupertinoTabController.index = 3;
          }

          if (index == 4) {
            _cupertinoTabController.index = 3;
          }
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {

          case 1:
            return AppSettings();

          case 2:
            return TasksCompleted();

          case 3:
            return _home();

          default:
            return _home();
        }
      },
    );
  }
}
