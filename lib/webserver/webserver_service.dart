import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

// void main() {
//   WebserverService webserverService = WebserverService();
//   webserverService.sendData(values: [
//     0.483, 0.027, 0.762, 0.138, 0.611, 0.905, 0.044, 0.316, 0.859, 0.725,
//     0.599, 0.173, 0.938, 0.287, 0.406, 0.687, 0.350, 0.092, 0.781, 0.219,
//     0.660, 0.017, 0.513, 0.118, 0.999, 0.230, 0.804, 0.061, 0.449, 0.674
//   ]);
// }

class WebserverService extends ChangeNotifier{
  final String webserverUriString = "http://145.24.223.80:8080/predict";
  bool isConnected = false;
  Map<String, dynamic>? lastKnownStatus;

  Future<String> sendData({required List<double> values}) async {
  try {
      final response = await post(
        Uri.parse(webserverUriString),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'values': values
        }),
      );
      if (response.statusCode == 201) { // HTTP 201 (Created)
        print('WebserverViewModel: Succes on ${response.statusCode}, ${response.headers}, ${response.body}');
        return jsonDecode(response.body)["prediction"];

      } else {
        print('WebserverViewModel: Error on: ${response.statusCode}, ${response.headers}, ${response.body}');
        return "";

      }
    } catch (e) {
      print("WebserverService: Error in checkStatus:$e");
      return "";
    }

  }

  Future<bool> checkStatus() async {
    try {
      final response = await get(
        Uri.parse("http://145.24.223.80:8080/status"),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) { // HTTP 200 (OK)
        lastKnownStatus = jsonDecode(response.body);
        print('WebserverViewModel: Succes on ${response.statusCode}, ${response.headers}, ${response.body}');
        return true;
        
      } else {
        print('WebserverViewModel: Error on: ${response.statusCode}, ${response.headers}, ${response.body}');
        return false;
      }

    } catch (e) {
      print("Error in checkStatus:$e");
      return false;
    }
  }
}


