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

SettingsModel _settingsModel;

SettingsModel get getSettingsModel => _settingsModel;

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

void listFiles() {
  var dir = Directory("$_dirPath");
  dir.list(recursive: true, followLinks: false).listen((FileSystemEntity i) {
    print(i.path);
  });
}

void saveSettings(String data) async {
  var file = File("$_dirPath/$_settings");
  await file.writeAsString(data, mode: FileMode.write);
}

void saveTaskList(String data) async {
  var file = File("$_dirPath/$_taskList");
  await file.writeAsString(data, mode: FileMode.write);
}

Future<List<Map<String, dynamic>>> _get(String name) async {

  var data = await File("$_dirPath/$name").readAsString();
  //empty, don't try and parse
  if (data.length == 0) return List<Map<String, dynamic>>();

  return (jsonDecode(data) as List<dynamic>).cast<Map<String, dynamic>>();
}

Future<Map<String, dynamic>> _getMap(String name) async {

  var data = await File("$_dirPath/$name").readAsString();
  //empty, don't try and parse
  if (data.length == 0) return Map<String, dynamic>();

  return (jsonDecode(data) as Map<dynamic,dynamic>).cast<String, dynamic>();
}

Future<Map<String, dynamic>> _getSettings() async {
  var settings =  await _getMap(_settings);

  // means empty file
  if(settings.length == 0)
  {
    var settings = SettingsModel(0,[
      Color(0xff7FC29B),
      Color(0xffEB9486),
      Color(0xffea80fc),
      Color(0xff616161),
      Color(0xff0288D1),
      Color(0xffC2185B),
      ],
      Color(0xffbbdefb));
    saveSettings(json.encode(settings.toJson()));
    return await _getMap(_settings);
  }
  return settings;
}

Future<List<Map<String, dynamic>>> getTaskList() async {
  return await _get(_taskList);
}
