import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:test_build/account.dart';
import 'package:test_build/appsettings.dart';
import 'package:test_build/taskscomplete.dart';
import 'package:test_build/updatetasklist.dart';
import 'package:test_build/widgets/taskwidget.dart';
import 'models/models.dart';
import 'updatetasklist.dart';
import 'utils/filesys.dart' as FileSys;
import 'utils/taskmanager.dart';
import 'api/api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileSys.initFileSystem();

  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<IdentityService>(IdentityService());
  getIt.registerSingleton<TaskService>(TaskService());
  getIt.registerSingleton<TaskManager>(TaskManager());

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
  TaskManager _taskManager;
  List<TaskModel> _tasks;

  @override
  void initState(){
    super.initState();
    _cupertinoTabController = CupertinoTabController(initialIndex: 3);
    _taskManager = GetIt.instance.get<TaskManager>();
    _tasks = List<TaskModel>();
    _refresh();
  }

  @override
  void dispose() {
    super.dispose();
    _cupertinoTabController.dispose();
  }

  void _refresh() async{
    List<TaskModel> i = (await _taskManager.getAll()).where((i) => !i.taskCompleted).toList();
    setState(() {
      _tasks = i;
    });
  }

  /// Updates the given task to done
  void _setTaskToDone(int id) async{
     await _taskManager.flipTaskStatus(id);
    _refresh();
  }

  /// Creates the views for the tasks, adds a delete and edit button
  List<Widget> createView(){
    var items = List<Widget>();
    for (var task in _tasks.where((i) => !i.taskCompleted)) {

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

  void _editTaskPopUp({int id = -1}) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskList(
            taskId: id,
          );
        });
        _refresh();
  }

  void _updateTaskPopUp() async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return UpdateTaskList();
        });
   // _taskManager.forceUpdate();
    _refresh();
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
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
        onTap: (index) {
          if(index >= 0) _refresh();

          if(index == 0){
            _accountPopUp();
            _cupertinoTabController.index = 3;
          }

          if (index == 4) {
            _updateTaskPopUp();
            _cupertinoTabController.index = 3;
          }
        },
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {

          case 1:
            return AppSettings();

          case 2:
            return TasksCompleted(); // Bug: find a way to refresh this page when tapped on :/

          case 3:
            return _home();

          default:
            return _home();
        }
      },
    );
  }
}
