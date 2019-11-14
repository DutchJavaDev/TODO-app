import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_build/models/models.dart';

String basePath = "";
String _dirPath = "";
String _dirName = "TodoAppDocuments";
String _settings = "appSettings.json";
String _taskList = "taskList.json";

/// All application settings will be stored in here, will be loaded once
SettingsModel _settingsModel;

/// Get the current loaded settings model
SettingsModel get getSettingsModel => _settingsModel;

/// This will run some checks before the application gets loaded
/// Checks if all the app files exist if not then they get created
Future<void> initFileSystem() async {

  final appDir = await getApplicationDocumentsDirectory();
  basePath = appDir.path;

  _dirPath = "$basePath/$_dirName";
  var dir = Directory("$_dirPath");

  if (!await dir.exists()) {
    await dir.create();
    await File("$_dirPath/$_settings").create();
    await File("$_dirPath/$_taskList").create();

  } else {

    for (String name in [_settings, _taskList]) {
      var file = File("$_dirPath/$name");
      if (!await file.exists()) await file.create();
    }

  }
  _settingsModel = SettingsModel.fromMappedJson(await _getSettings());
}

/// For debuging 
void listFiles() {
  var dir = Directory("$_dirPath");
  dir.list(recursive: true, followLinks: false).listen((FileSystemEntity i) {
    print(i.path);
  });
}

void saveSettings() async {
  var file = File("$_dirPath/$_settings");
  await file.writeAsString(jsonEncode(_settingsModel.toJson()), mode: FileMode.write);
}

void saveTaskList(String data) async {
  var file = File("$_dirPath/$_taskList");
  await file.writeAsString(data, mode: FileMode.write);
}

/// Reads a file as dynamic json list
Future<List<Map<String, dynamic>>> _get(String name) async {

  var data = await File("$_dirPath/$name").readAsString();
  //empty, don't try and parse
  if (data.length == 0) return List<Map<String, dynamic>>();

  return (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
}

/// Reads a file as dynamic json map
Future<Map<String, dynamic>> _getMap(String name) async {

  var data = await File("$_dirPath/$name").readAsString();
  //empty, don't try and parse
  if (data.length == 0) return Map<String, dynamic>();

  return (jsonDecode(data) as Map<dynamic,dynamic>).cast<String, dynamic>();
}

/// Loads the settings file
/// Gets called once, at startup
Future<Map<String, dynamic>> _getSettings() async {
  var settings =  await _getMap(_settings);

  // means empty file
  if(settings.length == 0)
  {
    _settingsModel = SettingsModel(0,[
      Color(0xff7FC29B),
      Color(0xffEB9486),
      Color(0xffea80fc),
      Color(0xff616161),
      Color(0xff0288D1),
      Color(0xffC2185B),
      ],
      Color(0xffbbdefb));
    saveSettings();
    return await _getMap(_settings);
  }
  return settings;
}

/// Gets all the tasks
Future<List<Map<String, dynamic>>> getTaskList() async {
  return await _get(_taskList);
}
