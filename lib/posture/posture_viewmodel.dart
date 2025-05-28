// import 'dart:async';
// import 'package:flutter/material.dart';
//
// class PostureViewModel extends ChangeNotifier {
//   String _postureId;
//   String get postureId => _postureId;
//
//   final void Function()? onStablePostureCallback; // <-- callback
//   PostureViewModel(this._postureId, {this.onStablePostureCallback}) {
//     simulatePostureChanges(); // Only during development
//   }
//
//   //FIXME: Add more posture responses and images if more lables are added
//   final Map<String, List<String>> postureResponse = {
//     "0": ["Je staat goed!", "assets/images/feet-icon-correct.png"],
//     "1": [
//       "Balans teveel naar links",
//       "assets/images/feet-icon-wrong-left.png",
//     ],
//     "2": [
//       "Balans teveel naar rechts",
//       "assets/images/feet-icon-wrong-right.png",
//     ],
//     "3": ["Niet op tenen", "assets/images/feet-icon-wrong-toes.png"],
//     "4": [
//       "Verkeerde voetpositie",
//       "assets/images/feet-icon-wrong-all.png",
//     ],
//   };
//
//   Timer? _stabilityTimer;
//   int _countdown = 3;
//   int get countdown => _countdown;
//
//   bool _isCountingDown = false;
//   bool get isCountingDown => _isCountingDown;
//
//   //start or cancel countdown if posture has been changed
//   void updatePosture(String newPostureId) {
//     if (_postureId == newPostureId) return;
//
//     _postureId = newPostureId;
//     notifyListeners();
//
//     if (_postureId == "0") {
//       _startCountdown();
//     } else {
//       _cancelCountdown();
//     }
//   }
//
//   //Start countdown
//   void _startCountdown() {
//     _cancelCountdown();
//     _isCountingDown = true;
//     _countdown = 3;
//     notifyListeners();
//
//     _stabilityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_postureId != "0") {
//         _cancelCountdown();
//         return;
//       }
//
//       _countdown--;
//       notifyListeners();
//
//       if (_countdown <= 0) {
//         _stabilityTimer?.cancel();
//         _isCountingDown = false;
//         notifyListeners();
//         onStablePostureDetected();
//       }
//     });
//   }
//
//   //Cancel countdown
//   void _cancelCountdown() {
//     _stabilityTimer?.cancel();
//     if (_isCountingDown) {
//       _isCountingDown = false;
//       notifyListeners();
//     }
//   }
//
//   void onStablePostureDetected() {
//     // TODO: Implement what should happen when posture is stable for 3 seconds
//     // debugPrint("Stable posture detected for 3 seconds!");
//     // load to measure page let know that length and weight will be measured
//
//     onStablePostureCallback?.call();
//   }
//
//
//   String get message => postureResponse[_postureId]?[0] ?? "Onbekende houding";
//   String get imagePath =>
//       postureResponse[_postureId]?[1] ?? "assets/images/feet-icon-default.png";
//
//   @override
//   void dispose() {
//     _stabilityTimer?.cancel();
//     super.dispose();
//   }
//
//
//   // Simulate posture changes for development purposes
//   void simulatePostureChanges() {
//     Future.delayed(const Duration(seconds: 1), () {
//       updatePosture("4");
//     });
//
//     Future.delayed(const Duration(seconds: 3), () {
//       updatePosture("1"); //links
//     });
//
//     Future.delayed(const Duration(seconds: 3), () {
//       updatePosture("2");
//     });
//
//     Future.delayed(const Duration(seconds: 2), () {
//       updatePosture("3");//links
//     });
//
//     Future.delayed(const Duration(seconds: 4), () {
//       updatePosture("0");
//     });
//   }
// }

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

  final Stopwatch correctStopwatch = Stopwatch();
  bool isTrackingCorrect = false;
  int correctSeconds = 0;
  bool isCorrectIndefinite = false;

  BluetoothDevice? get connectedDevice => bluetoothServiceApp.specificDevice;
  String dynamicTarget = "";
  List<List<dynamic>> buffer = [];
  String lastKnownPrediction = "";

  String get message {
    String val =
        predictionMapping[lastKnownPrediction]?[0] ?? "Onbekende houding";
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
    print("\t\t\t\tPostureViewModel: Running mainMeasurer");
    if (connectedDevice != null) {
      setListener();
      print("\t\t\t\tPostureViewModel: Sending first request");
      bluetoothServiceApp.writeToDevice("DISAPPROVED");
    } else {
      print("\t\t\t\tPostureViewModel: No connected device");
    }
  }

  void setListener() async {
    if (bluetoothServiceApp.notifyCharacteristicSubscribtion != null) {
      print("\t\t\t\tPostureViewModel: Closing already active listener");
      disposeListener();
    }
    print("\t\t\t\tPostureViewModel: Opening listener");
    await bluetoothServiceApp.notifyCharacteristic!.setNotifyValue(true);
    bluetoothServiceApp.notifyCharacteristicSubscribtion = bluetoothServiceApp
        .notifyCharacteristic!
        .onValueReceived
        .listen((value) async {
          print(
            "\t\t\t\tPostureViewModel: Recieved a value on buffer:${buffer.length}",
          );
          try {
            if (!isCorrectIndefinite) {
              final valueList = bluetoothServiceApp.decimalChanger(value);
              buffer.add(valueList[1]);
              print("\t\t\t\tPostureViewModel: Buffered foot: ${valueList[0]}");
              if (buffer.length == 2) {
                final flatList = buffer.expand((x) => x).toList();
                print("\t\t\t\tPostureViewModel: sending flattened buffer");
                lastKnownPrediction = await webserverService.sendData(
                  values: flatList,
                  target: dynamicTarget,
                );
                // notifyListeners();
                print(
                  "\t\t\t\tPostureViewModel: Recieved lastKnownPrediction: $lastKnownPrediction",
                );
                if (lastKnownPrediction == "correct_posture") {
                  print("\t\t\t\tPostureViewModel: Active posture is correct");
                  if (!isTrackingCorrect) {
                    print("\t\t\t\tPostureViewModel: Started tracking time");
                    correctStopwatch.start();
                    isTrackingCorrect = true;
                    notifyListeners();
                  } else {
                    correctSeconds = correctStopwatch.elapsed.inSeconds;
                    print(
                      "\t\t\t\tPostureViewModel: Tracked time: $correctSeconds",
                    );
                    if (correctSeconds > 3) {
                      print(
                        "\t\t\t\tPostureViewModel: Recent correct postions succesfully closed measurement ",
                      );
                      isCorrectIndefinite = true;
                      isTrackingCorrect = false;
                      correctStopwatch.reset();
                      correctStopwatch.stop();
                      notifyListeners();
                    }
                  }
                  print(
                    "\t\t\t\tPostureViewModel: Good & requesting new block",
                  );
                  bluetoothServiceApp.writeToDevice("APPROVED");
                } else {
                  isTrackingCorrect = false;
                  correctStopwatch.reset();
                  correctStopwatch.stop();
                  correctSeconds = 0;
                  notifyListeners();
                  print("\t\t\t\tPostureViewModel: Bad & requesting new block");
                  bluetoothServiceApp.writeToDevice("DISAPPROVED");
                }
                print("\t\t\t\tPostureViewModel: Clearing buffer");
                buffer.clear();
              }
              if (buffer.length > 2) {
                print(
                  "\t\t\t\tPostureViewModel: Error Blocked buffer size Too Large: ${buffer.length}",
                );
                buffer.clear();
              }
            }
          } catch (e) {
            print("\t\t\t\tPostureViewModel: Error at setListener: $e");
          }
          print("\t\t\t\tPostureViewModel: async verwerkt");
        });
  }

  void disposeListener() {
    try {
      print("\t\t\t\tPostureViewModel: Cancelling listener");
      bluetoothServiceApp.notifyCharacteristicSubscribtion!.cancel();
      bluetoothServiceApp.notifyCharacteristicSubscribtion = null;
    } catch (e) {
      print("\t\t\t\tPostureViewModel: Error at disposeListener: $e");
    }
  }
}
