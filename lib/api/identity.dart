import 'dart:convert';

import 'models.dart';
import '../utils/filesys.dart' as FileSys;
import 'package:http/http.dart' as http;

class IdentityService{

  static final String registerUrl = "Identity/register";
  static final String loginUrl = "Identity/login";

  static Future<ResponseModel> registerAccount(String userName,String userPassword) async
  {
    var model = RegisterModel(userName,userPassword,FileSys.getAppType).toJson();

    return await _postRequest("${FileSys.getBaseUrl}$registerUrl",body: model);
  }

  static Future<ResponseModel> requestJwtToken(String userEmail,String userPassword) async
  {
    var model = LoginModel(userEmail, userPassword);

    return await _postRequest("${FileSys.getBaseUrl}$loginUrl",body: model);
  }
  
  static Future<ResponseModel> _postRequest(String url,{dynamic body = ""}) async
  {
    try {
      var request = await http.post(url,body: body);
      return ResponseModel.fromJson(json.decode(request.body));
    } catch (e) {
      return ResponseModel(false, 500, "Failed", "");
    }
  }
}


