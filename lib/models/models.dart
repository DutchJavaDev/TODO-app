import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';

import '../utils/extension.dart';

class SettingsModel
{
  List<Color> _backgroundColors;
  int _headerFontSize;
  int _descriptionFontSize;
  String _jwtToken = "";

  int colorIndex;
  Color taskHeaderColor;

  List<Color> get getBackgroundColors => _backgroundColors;
  double get getHeaderFontSize => _headerFontSize.toDouble();
  double get getDescriptionFontSize => _descriptionFontSize.toDouble();
  bool get hasJwtToken => !_jwtToken.isNullOrEmpty();
  String get getJwtToken => _jwtToken;
  
  SettingsModel(this.colorIndex,this._backgroundColors,this.taskHeaderColor,this._headerFontSize,this._descriptionFontSize);

  void setHeaderFontSize(double newValue)
  {
    _headerFontSize = newValue.round();
  }

  void setDescriptionFontSize(double newValue)
  {
    _descriptionFontSize = newValue.round();
  }

  void removeColor(Color color)
  {
    _backgroundColors.removeWhere((i) => i.value == color.value);
  }

  void addColor(Color color)
  {
    _backgroundColors.add(color);
  }

  void setToken(String token)
  {
    _jwtToken = token;
  }
  
  SettingsModel.fromMappedJson(Map<String,dynamic> json) : 
    colorIndex = json["colorIndex"],
    _backgroundColors = _decodeColors(json["backgroundColors"]),
    taskHeaderColor = Color(int.parse(json["taskHeaderColor"].toString())),
    _headerFontSize = json["headerFontSize"],
    _descriptionFontSize = json["descriptionFontSize"],
    _jwtToken = json["jwt_token"]
    ;

  Map<String,dynamic> toJson() => {
    "colorIndex":colorIndex,
    "backgroundColors": _encodeColors(_backgroundColors),
    "taskHeaderColor": taskHeaderColor.value,
    "headerFontSize": _headerFontSize,
    "descriptionFontSize": _descriptionFontSize,
    "jwt_token": _jwtToken.isEmpty ? "" : _jwtToken
  };

  static List<Color> _decodeColors(dynamic colors)
  {
    var _colors = List<Color>();

    var data = (jsonDecode(colors.toString()) as List<dynamic>).cast<int>();
    
    data.forEach((f) => _colors.add(Color(f)));

    return _colors;
  }

  static List<int> _encodeColors(List<Color> colors)
  {
    var _colors = List<int>();
    colors.forEach((c) => _colors.add(c.value));
    return _colors;
  }
}


class TaskModel
{
  int taskId = 0;
  String taskTitle;
  String taskDescription;
  bool taskCompleted;
  Color taskColor;

  TaskModel(this.taskTitle, this.taskDescription, this.taskCompleted, this.taskColor);

  TaskModel.fromMappedJson(Map<String, dynamic> json) :
            taskId = int.parse(json["id"].toString()),
            taskTitle = json["taskTitle"].toString(),
            taskDescription = json["taskDescription"].toString(),
            taskCompleted = json["taskCompleted"].toString().toLowerCase() == 'true',
            taskColor = Color(int.parse(json["taskColor"].toString()));

  Map<String,dynamic> toJson() => {
      "id":taskId,
      "tasktitle":taskTitle,
      "taskdescription":taskDescription,
      "taskcompleted":taskCompleted,
      "taskcolor":taskColor.value.toString()
  };
}

