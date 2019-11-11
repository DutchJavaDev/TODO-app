import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:uuid/uuid.dart';
import '../utils/filesys.dart' as FileSys;

final _tasks = List<TaskModel>();
final _gen = Uuid();
Color _defaultColor;

/// Gets called when the app starts, loads all the saved tasks
Future<void> initManager() async {
  _defaultColor = FileSys.getSettingsModel.taskHeaderColor;
  var items = await FileSys.getTaskList();
  items.forEach((i) => _tasks.add(TaskModel.fromMappedJson(i)));
}

/// Saves the current task list to file, gets called when a task has been added,deleted and updated
void _updateTaskList() {
  var jsonData = List<Map<String, dynamic>>();
  _tasks.forEach((f) => jsonData.add(f.toJson()));
  FileSys.saveTaskList(json.encode(jsonData));
}

/// Adds a new task
void addTask(String title, String description) {
  addTaskWithColor(title, description, _defaultColor);
}

/// Adds a task with a given color
void addTaskWithColor(String title, String description, Color color) {
  _tasks.add(TaskModel(_gen.v4(), title, description, false, color));
  _updateTaskList();
}

/// Updates a task when edited
void updateTask(TaskModel model) {
  final old = _tasks.where((i) => i.taskId == model.taskId).single;

  if (old != null) {
    final index = _tasks.indexOf(old);
    _tasks[index] = model;
    _updateTaskList();
  }
}

/// Resets a task
void revertTask(String id)
{
  final model = _tasks.where((i) => i.taskId == id).single;

  if(model != null)
  {
    model.taskDone = false;
    updateTask(model);
  }
}

/// Removes a task
void deleteTask(String id) {
  _tasks.removeWhere((i) => i.taskId == id);
  _updateTaskList();
}

/// Delete's all the tasks
void deleteAllDoneTasks() {
  _tasks.removeWhere((i) => i.taskDone);
  _updateTaskList();
}

/// Returns the number of tasks that are completed
int get completedTaskLenght => _tasks.where((i) => i.taskDone).length;

/// Returns the number of task that are still open
int get openTaskLenght => _tasks.where((i) => !i.taskDone).length;

/// Gets all the tasks that are done
List<TaskModel> get completedTask => _tasks.where((i) => i.taskDone).toList();

/// Get all the current tasks that are not done
List<TaskModel> get openTasks => _tasks.where((i) => !i.taskDone).toList();

/// Gets a task by its id
TaskModel getTaskById(String id) => _tasks.singleWhere((i) => i.taskId == id);

/// Gets all tasks that have the same color
List<TaskModel> getTasksByColor(Color color) => _tasks.where((i) => i.taskColor == color).toList();