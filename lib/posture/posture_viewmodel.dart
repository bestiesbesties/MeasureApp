import 'package:flutter/material.dart';
import 'package:wonder/webserver/webserver_service.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class PostureViewModel extends ChangeNotifier {
  final BluetoothServiceApp bluetoothServiceApp;
  final WebserverService webserverService;

  PostureViewModel({
    required this.bluetoothServiceApp,
    required this.webserverService,
  });

  // final Stopwatch correctStopwatch = Stopwatch();
  bool isTrackingCorrect = false;
  final ValueNotifier<Stopwatch> correctStopwatch = ValueNotifier(Stopwatch());
  bool isCorrectIndefinite = false;
  List<dynamic> measurementIndefinite = [-1,-1];

  BluetoothDevice? get connectedDevice => bluetoothServiceApp.specificDevice;
  String dynamicTarget = "";
  List<List<dynamic>> buffer = [];
  String lastKnownPrediction = "";

  bool get isConnected =>
      bluetoothServiceApp.specificDevice?.isConnected ?? false;

  String get message {
    String val =
        predictionMapping[lastKnownPrediction]?[0] ?? "";
    // print("\t\t\t\tPostureViewModel: Gotten message as : $val");
    return val;
  }

  String get imagePath {
    String val =
        predictionMapping[lastKnownPrediction]?[1] ??
        "assets/images/no-icon.png";
    // print("\t\t\t\tPostureViewModel: Gotten imagePath as : $val");
    return val;
  }

  final Map<String, List<String>> predictionMapping = {
    "empty_mat": [
      "Je staat niet op de mat!",
      "assets/images/feet-icon-default.png",
    ],
    "correct_posture": [
      "Je staat  goed!",
      "assets/images/feet-icon-correct.png",
    ],
    "inbalance_left": [
      "Je staat te veel naar links...",
      "assets/images/feet-icon-wrong-left.png",
    ],
    "inbalance_right": [
      "Je staat te veel naar rechts...",
      "assets/images/feet-icon-wrong-right.png",
    ],
    "on_toes": [
      "Je staat op je tenen...",
      "assets/images/feet-icon-wrong-toes.png",
    ],
    "wrong_foot_position": [
      "Je voeten staan verkeerd...",
      "assets/images/feet-icon-wrong-all.png",
    ],
  };

  void mainMeasurer() async {
    setEventHandler();
    print("\t\t\t\tPostureViewModel: Running mainMeasurer");
    if (connectedDevice != null) {
      setListener();
      print("\t\t\t\tPostureViewModel: Sending first request");
      // bluetoothServiceApp.writeToDevice("DISAPPROVED");
      bluetoothServiceApp.writeToDevice("START");
      // bluetoothServiceApp.writeToDevice("DISAPPROVED");
    } else {
      print("\t\t\t\tPostureViewModel: No connected device");
    }
  }

  void setEventHandler() {
    webserverService.connectToSocket();
    // webserverService.sendRandomValues();

    webserverService.socket!.on('message', (data) {
      lastKnownPrediction = data["prediction"] ?? "";
      notifyListeners();
      print("WebserverService: Recieved message $lastKnownPrediction");
    });
  }

  void setListener() async {
    if (bluetoothServiceApp.notifyCharacteristicSubscribtion != null) {
      print("\t\t\t\tPostureViewModel: Closing already active listener");
      disposeListener();
    }
    print("\t\t\t\tPostureViewModel: Opening listener");
    await bluetoothServiceApp.notifyCharacteristic!.setNotifyValue(true);
    bluetoothServiceApp.notifyCharacteristicSubscribtion = bluetoothServiceApp.notifyCharacteristic!.onValueReceived.listen((value) async {
      print("\t\t\t\tPostureViewModel: value len: ${value.length}");

      if (value.length == 10) {
        print("\t\t\t\tPostureViewModel: : $value");
        measurementIndefinite = bluetoothServiceApp.valuesFromFloatsAsBytes(value);
        notifyListeners();

      }
      print("\t\t\t\tPostureViewModel: Recieved a value on buffer:${buffer.length}");
      try {
        if (!isCorrectIndefinite) {
          final valueList = bluetoothServiceApp.decimalChanger(value);
          buffer.add(valueList[1]);
          print("\t\t\t\tPostureViewModel: Buffered foot: ${valueList[0]}");
          if (buffer.length == 2) {
            final flatList = buffer.expand((x) => x).toList();
            print("\t\t\t\tPostureViewModel: sending flattened buffer");
            webserverService.sendMessage("inference", <String, dynamic>{
              "values" : flatList
            });
            notifyListeners();
            
            print("\t\t\t\tPostureViewModel: Recieved lastKnownPrediction: $lastKnownPrediction");
            if (lastKnownPrediction == "correct_posture") {
              print("\t\t\t\tPostureViewModel: Active posture is correct");
              if (!isTrackingCorrect) {
                print("\t\t\t\tPostureViewModel: Started tracking time");
                correctStopwatch.value.start();
                bluetoothServiceApp.writeToDevice("START_TIMER");
                print("\t\t\t\tPostureViewModel: Good & requesting new block");
                bluetoothServiceApp.writeToDevice("APPROVED");
                isTrackingCorrect = true;
                notifyListeners();
              } else {
                // correctSeconds.value = correctStopwatch.elapsed.inSeconds;
                // notifyListeners();
                // print("\t\t\t\tPostureViewModel: Tracked time: ${correctSeconds.value}");
                if (correctStopwatch.value.elapsed.inSeconds > 5) {
                  print("\t\t\t\tPostureViewModel: Recent correct postions succesfully closed measurement ");
                  isCorrectIndefinite = true;
                  isTrackingCorrect = false;
                  bluetoothServiceApp.writeToDevice("FINISH_TIMER");
                  correctStopwatch.value.reset();
                  correctStopwatch.value.stop();
                  notifyListeners();
                  } else {
                    print("\t\t\t\tPostureViewModel: Good & requesting new block");
                    bluetoothServiceApp.writeToDevice("APPROVED");
                }
              }
            } else {
              bluetoothServiceApp.writeToDevice("CANCEL_TIMER");
              isTrackingCorrect = false;
              correctStopwatch.value.reset();
              correctStopwatch.value.stop();
              // correctSeconds.value = 0;
              notifyListeners();
              print("\t\t\t\tPostureViewModel: Bad & requesting new block");
              bluetoothServiceApp.writeToDevice("DISAPPROVED");
            }
            print("\t\t\t\tPostureViewModel: Clearing buffer");
            buffer.clear();
          } if (buffer.length > 2) {
            print("\t\t\t\tPostureViewModel: Error Blocked buffer size Too Large: ${buffer.length}");
            buffer.clear();
          }
          notifyListeners();
        }
      } catch (e) {
        print("\t\t\t\tPostureViewModel: Error at setListener: $e");
      }
    });
  }

  void disposeListener() {
    try {
      bluetoothServiceApp.writeToDevice("CONNECTED");
      print("\t\t\t\tPostureViewModel: Cancelling listener");
      bluetoothServiceApp.notifyCharacteristicSubscribtion!.cancel();
      bluetoothServiceApp.notifyCharacteristicSubscribtion = null;
    } catch (e) {
      print("\t\t\t\tPostureViewModel: Error at disposeListener: $e");
    }
  }
}
