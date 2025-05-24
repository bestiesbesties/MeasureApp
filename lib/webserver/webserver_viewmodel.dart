import 'package:flutter/material.dart';
import 'package:wonder/webserver/webserver_service.dart';

class WebserverViewModel extends ChangeNotifier {
  final WebserverService webserverService;
  WebserverViewModel({required this.webserverService});

  String connectionState = "Disconnected";
  Map<String,String>? connectionTelemetry;

  void tryStatus() async {
    try {
      connectionState = "Connecting";
      notifyListeners();
      bool condition = await webserverService.checkStatus();
      if (condition) {
        connectionState = "Connected";
        connectionTelemetry = {};
        connectionTelemetry!["Verbonden met"] = webserverService.lastKnownStatus!["platform"] ?? "Unknown";
        connectionTelemetry!["cpu_load"] = webserverService.lastKnownStatus!["cpu_load"] ?? "Unknown";
        connectionTelemetry!["memory"] = webserverService.lastKnownStatus!["memory"] ?? "Unknown";
        connectionTelemetry!["uptime"] = webserverService.lastKnownStatus!["uptime"] ?? "Unknown";
        connectionTelemetry!["data_size"] = webserverService.lastKnownStatus!["data_size"] ?? "Unknown";
        notifyListeners();
      } else {
        connectionState = "Failed";
        notifyListeners();
      }
    } catch (e) {
      print("WebserverViewModel: Error in tryStatus: $e");
      connectionState = "Failed";
      notifyListeners();
    }
  }
}