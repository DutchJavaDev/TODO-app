import 'dart:convert';
import 'dart:ui';

class SettingsModel
{
  int colorIndex;
  List<Color> _backgroundColors;
  Color taskHeaderColor;

  List<Color> get getBackgroundColors => _backgroundColors;
  

  SettingsModel(this.colorIndex,this._backgroundColors,this.taskHeaderColor);


  void removeColor(Color color)
  {
    _backgroundColors.removeWhere((i) => i.value == color.value);
  }

  void addColor(Color color)
  {
    _backgroundColors.add(color);
  }


  SettingsModel.fromMappedJson(Map<String,dynamic> json) : 
    colorIndex = json["colorIndex"],
    _backgroundColors = _decodeColors(json["backgroundColors"]),
    taskHeaderColor = Color(int.parse(json["taskHeaderColor"].toString()));

  Map<String,dynamic> toJson() => {
    "colorIndex":colorIndex,
    "backgroundColors": _encodeColors(_backgroundColors),
    "taskHeaderColor": taskHeaderColor.value
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
  String taskId;
  String taskTitle;
  String taskDescription;
  bool taskDone;
  Color taskColor;

  TaskModel(this.taskId, this.taskTitle, this.taskDescription, this.taskDone, this.taskColor);

  TaskModel.fromMappedJson(Map<String, dynamic> json) :
            taskId = json["taskId"].toString(),
            taskTitle = json["taskTitle"].toString(),
            taskDescription = json["taskDescription"].toString(),
            taskDone = json["taskDone"].toString().toLowerCase() == 'true',
            taskColor = Color(int.parse(json["taskColor"].toString()));

  Map<String,dynamic> toJson() => {
      "taskId":taskId,
      "taskTitle":taskTitle,
      "taskDescription":taskDescription,
      "taskDone":taskDone,
      "taskColor":taskColor.value
  };
}

