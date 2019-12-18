
import 'package:get_it/get_it.dart';
import 'package:test_build/models/models.dart';
import '../api/api.dart';

class TaskManager{

  TaskService _taskService;
  List<TaskModel> _taskCpy = List<TaskModel>();
  bool _updateList = true;
  
  TaskManager()
  {
    _taskService = GetIt.instance.get<TaskService>();
  }

  Future<List<TaskModel>> getAll() async{
    if(_updateList){
      _updateList = false;
      _taskCpy = await _taskService.getAllTasks();
      return _taskCpy;
    }
    return _taskCpy;
  }

  TaskModel getTaskById(int id){
    return _taskCpy.firstWhere((i) => i.taskId == id);
  }

  void forceUpdate(){
    _updateList = true;
  }

  Future<void> addTask(TaskModel model) async{
    await _taskService.addTask(model);
    _updateList = true;
  }

  Future<void> updateTask(TaskModel model) async{
    await _taskService.updateTask(model);
    _updateList = true;
  }

  Future<void> removeTask(int id) async{
    await _taskService.deleteTaskById(id);
    _updateList = true;
  }

  Future<void> flipTaskStatus(int id) async{
    var model = _taskCpy.firstWhere((i) => i.taskId == id);

    if(model == null) return;

    model.taskCompleted = !model.taskCompleted;

    await _taskService.updateTask(model);
    _updateList = true;
  }
}