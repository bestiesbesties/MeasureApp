import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'dart:math';

void main() async {
  WebserverService webserverService = WebserverService();
  webserverService.connectToSocket();

  // List<int> values = [24, 35, 52, 44, 25, 16, 11, 89, 192, 206, 142, 70, 23, 1, 230, 342, 275, 260, 182, 125, 93, 670, 788, 803, 773, 662, 502, 366, 578, 763, 702, 573, 355, 183, 89, 585, 711, 666, 533, 450, 347, 258, 8, 34, 56, 12, 1, 2, 1, 216, 297, 403, 264, 225, 169, 119, 131, 142, 215, 193, 109, 86, 53, 368, 380, 413, 490, 468, 219, 131, 528, 555, 591, 709, 718, 552, 363, 207, 224, 259, 423, 515, 256, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 24, 33, 53, 44, 36, 33, 91, 264, 432, 513, 451, 481, 341, 87, 166, 325, 390, 383, 353, 323, 291, 448, 653, 684, 700, 711, 596, 447, 602, 722, 812, 859, 874, 842, 44, 106, 163, 204, 343, 503, 361, 90, 152, 211, 226, 355, 368, 317, 0, 0, 0, 0, 14, 0, 0, 0, 0, 1, 7, 16, 0, 0, 0, 0, 46, 120, 65, 12, 7, 232, 412, 688, 731, 650, 569, 560, 30, 80, 404, 383, 119, 91, 86, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  // webserverService.sendMessage("inference", <String, dynamic>{"values" : values});

  webserverService.startSendingRandomValues();
}

class WebserverService {
  final String webserverUriString = "//145.24.223.80:8080";
  bool isConnected = false;
  Map<String, dynamic>? lastKnownStatus;
  Socket? socket;

  String? lastKnownPrediction;

  void connectToSocket() {
    print("Connecting...");

    socket = io("ws:$webserverUriString", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket!.connect();

    socket!.on('connect', (_) {
      print('Connected to backend');
    });

    socket!.on('message', (data) {
      print("WebserverService: Recieved message");
      lastKnownPrediction = data["prediction"];
      print(lastKnownPrediction);
    });
  }

  void sendMessage(String event, Map<String, dynamic> data) {
    print("WebserverService: Sending message");
    socket!.emit(event, data);
  }

  void disconnectFromSocket() {
    print("WebserverService: Disconnecting");
    socket!.disconnect();
  }

  void startSendingRandomValues() {
    final random = Random();

    Timer.periodic(Duration(milliseconds:500), (timer) {
      List<int> values = List.generate(210, (_) => random.nextInt(1024));
      // print("values $values");
      sendMessage("inference", <String, dynamic>{"values": values});
    });
  }

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




