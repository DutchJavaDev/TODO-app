import 'dart:convert';
import 'dart:io';

import 'models.dart';
import '../utils/filesys.dart' as FileSys;
import 'package:http/http.dart' as http;

class IdentityService {
  static final String _registerUrl = "Identity/register";
  static final String _loginUrl = "Identity/login";
  static bool _isDevMode = false;

  static void initDevMode() {
    _isDevMode = true;
  }

  static Future<ResponseModel> registerAccount(String userName, String userPassword) async {
    var model = RegisterModel(userName, userPassword, FileSys.getAppType).toJson();
    return await _postRequest("${FileSys.getBaseUrl}$_registerUrl",body: model);
  }

  static Future<ResponseModel> requestJwtToken(String userEmail, String userPassword) async {
    var model = LoginModel(userEmail, userPassword);
    return await _postRequest("${FileSys.getBaseUrl}$_loginUrl", body: model);
  }

  static Future<ResponseModel> _postRequest(String url,{dynamic body}) async {

    if (_isDevMode) return _postRequestDev(url, body: body);

    try {
      var request = await http.post(url, body: body);
      return ResponseModel.fromJson(json.decode(request.body));
    } catch (e) {
      return ResponseModel(false, 500, "Failed", e);
    }
  }

  static Future<ResponseModel> _postRequestDev(String url,{dynamic body = ""}) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      HttpClientRequest request = await client.postUrl(Uri.parse(url));

      request.headers.set('content-type', 'application/json');

      if (body != null) {
        request.add(utf8.encode(json.encode(body)));
      }

      HttpClientResponse response = await request.close();

      String reply = await response.transform(utf8.decoder).join();

      return ResponseModel.fromJson(json.decode(reply));
    } catch (e) {
      print(e);
      return ResponseModel(false, 500, "Failed", e);
    }
  }
}
