import 'package:http/http.dart' as http;

Future<bool> hasConnection() async {
  var response = await http.get("https://www.google.com");
  return response.statusCode == 200;
}