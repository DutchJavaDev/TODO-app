import 'package:http/http.dart' as http;
import 'package:test_build/models/models.dart';
import 'dart:convert';
import 'dart:io';

import 'models.dart';
import '../utils/filesys.dart' as FileSys;
import '../utils/extension.dart';

final String _baseUrl = FileSys.getBaseUrl;

class IdentityService {
  static final String _registerUrl = "Identity/register".prepend(_baseUrl);
  static final String _loginUrl = "Identity/login".prepend(_baseUrl);
  
  Future<ResponseModel> registerAccount(String userName, String userPassword) async {
    var model = RegisterModel(userName, userPassword, FileSys.getAppType).toJson();
    
    var body = await _postRequest(_registerUrl,body: model);

    if(body.contains("Failed")) return _failedRequest();
    
    return ResponseModel.fromJson(json.decode(body));
  }

  Future<ResponseModel> requestJwtToken(String userEmail, String userPassword) async {
    var model = LoginModel(userEmail, userPassword);

    var body = await _postRequest(_loginUrl,body: model);

    if(body.contains("Failed")) return _failedRequest();
    
    return ResponseModel.fromJson(json.decode(body));
  }
}

class TaskService{
  static final String _addTaskUrl = "Task/Add".prepend(_baseUrl);
  static final String _updateTaskUrl = "Task/Update".prepend(_baseUrl);
  //static final String _getTaskByIdUrl = "Task/ById[ID]".setPrefix(_baseUrl);
  static final String _getAllTaskUrl = "Task/All".prepend(_baseUrl);
  //static final String _deleteTaskUrl = "Task/Delete".setPrefix(_baseUrl);
  static final String _deleteTaskByIdUrl = "Task/Delete/".prepend(_baseUrl);

  Future<bool> addTask(TaskModel model) async{
    
    var body = await _postRequest(_addTaskUrl,body: model.toJson(),header: _getHeaders());

    if(body.contains("Failed")) return false;

    var response = ResponseModel.fromJson(jsonDecode(body));

    print(response.responseData);

    return response.isSuccess;
  }

  Future<bool> updateTask(TaskModel model) async{
    var body = await _postRequest(_updateTaskUrl,body: model.toJson(),header: _getHeaders()); 

    if(body.contains("Failed")) return false;

    var response = ResponseModel.fromJson(jsonDecode(body));

    return response.isSuccess;
  }

  Future<List<TaskModel>> getAllTasks() async{
    var body = await _getRequest(_getAllTaskUrl,header: _getHeaders());
    
    if(body.contains("Failed")) return List<TaskModel>();

    var response = ResponseModel.fromJson(json.decode(body));

    if(!response.isSuccess) return List<TaskModel>();

    var taskData = response.responseData as Map<String,dynamic>;

    var tasks = List<TaskModel>();

    for(var task in taskData["tasks"].toList())
    {
      tasks.add(TaskModel.fromMappedJson(task as Map<String,dynamic>));
    }

    return tasks;
  }

  Future<bool> deleteTaskById(int id) async{
    var body = await _postRequest(_deleteTaskByIdUrl.append(id.toString()),header: _getHeaders());

    if(body.contains("Failed")) return false;
    return true;
  }
}

  Map<String,String> _getHeaders()
  {
    return {
      HttpHeaders.authorizationHeader : "Bearer ${FileSys.getJWT}",
      HttpHeaders.contentTypeHeader : "application/json"
    };
  }

  Future<String> _getRequest(String url, {Map<String,String> header}) async{
    try {
      var request = await http.get(url,headers: header);
      return request.body.isNullOrEmpty() ? "" : request.body;
    } catch (e) {
      return await _getRequestFix(url,header: header);
    }
  }

  Future<String> _getRequestFix(String url, {Map<String,String> header}) async{
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request = await client.getUrl(Uri.parse(url));

      if(header != null)
      {
        for(int i = 0; i < header.length; i++)
        {
          request.headers.add(header.keys.elementAt(i), header.values.elementAt(i));
        }
      }

      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      client.close();

      return reply.isNullOrEmpty() ? "" : reply;
    } catch (e) {
      print(e);
      return "GetRequest Failed";
    }
  }


  Future<String> _postRequest(String url,{dynamic body, Map<String,String> header}) async {
    try {
      var request = await http.post(url, body: body, headers: header);
      return request.body.isNullOrEmpty() ? "" : request.body;
    } catch (e) {
      return _postRequestFix(url, body: body, header: header);
    }
  }


  Future<String> _postRequestFix(String url,{dynamic body, Map<String,String> header}) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request = await client.postUrl(Uri.parse(url));

      request.headers.set('content-type', 'application/json');
      
      if(header != null)
      {
        for(int i = 0; i < header.length; i++)
        {
          request.headers.add(header.keys.elementAt(i), header.values.elementAt(i));
        }
      }

      if (body != null) {
        request.add(utf8.encode(jsonEncode(body)));
      }

      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();
      
      client.close();

      return reply.isNullOrEmpty() ? "" : reply;
    } catch (e) {
      print(e);
      return "PostRequest Failed";
    }
  }

  ResponseModel _failedRequest(){
    return ResponseModel(false, 500, "Failed", "");  
  }
