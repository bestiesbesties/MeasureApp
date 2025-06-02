import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:math';
import 'dart:async';

class  WebserverService extends ChangeNotifier{
  final String webserverUriString = "//145.24.223.80:8080";
  bool isConnected = false;
  Map<String, dynamic>? lastKnownStatus;
  Socket? socket;

  // String? lastKnownPrediction;

  Timer? randomTimer;

  void connectToSocket() {
    print("Connecting...");

    socket = io("http:$webserverUriString", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print('Connected to backend');
    });
  }

  void sendMessage(String event, Map<String, dynamic> data) {
    print("WebserverService: Sending message: $data");
    socket!.emit(event, data);
  }
  //
  // void sendRandomValues() {
  //   if (randomTimer != null && randomTimer!.isActive) return;
  //
  //   final random = Random();
  //   randomTimer = Timer.periodic(Duration(milliseconds:500), (timer) {
  //     List<int> values = List.generate(210, (_) => random.nextInt(1024));
  //     // print("values $values");
  //     sendMessage("inference", <String, dynamic>{"values": values});
  //   });
  // }

  Future<bool> checkStatus() async {
    try {
      final response = await get(
        Uri.parse("http:$webserverUriString/"),
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
