import 'dart:async';
import 'package:flutter/material.dart';

class PostureViewModel extends ChangeNotifier {
  String _postureId;
  String get postureId => _postureId;

  final void Function()? onStablePostureCallback; // <-- callback
  PostureViewModel(this._postureId, {this.onStablePostureCallback}) {
    simulatePostureChanges(); // Only during development
  }

  //FIXME: Add more posture responses and images if more lables are added
  final Map<String, List<String>> postureResponse = {
    "0": ["Je staat goed!", "assets/images/feet-icon-correct.png"],
    "1": [
      "Balans teveel naar links",
      "assets/images/feet-icon-wrong-left.png",
    ],
    "2": [
      "Balans teveel naar rechts",
      "assets/images/feet-icon-wrong-right.png",
    ],
    "3": ["Niet op tenen", "assets/images/feet-icon-wrong-toes.png"],
    "4": [
      "Verkeerde voetpositie",
      "assets/images/feet-icon-wrong-all.png",
    ],
  };

  Timer? _stabilityTimer;
  int _countdown = 3;
  int get countdown => _countdown;

  bool _isCountingDown = false;
  bool get isCountingDown => _isCountingDown;

  //start or cancel countdown if posture has been changed
  void updatePosture(String newPostureId) {
    if (_postureId == newPostureId) return;

    _postureId = newPostureId;
    notifyListeners();

    if (_postureId == "0") {
      _startCountdown();
    } else {
      _cancelCountdown();
    }
  }

  //Start countdown
  void _startCountdown() {
    _cancelCountdown();
    _isCountingDown = true;
    _countdown = 3;
    notifyListeners();

    _stabilityTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_postureId != "0") {
        _cancelCountdown();
        return;
      }

      _countdown--;
      notifyListeners();

      if (_countdown <= 0) {
        _stabilityTimer?.cancel();
        _isCountingDown = false;
        notifyListeners();
        onStablePostureDetected();
      }
    });
  }

  //Cancel countdown
  void _cancelCountdown() {
    _stabilityTimer?.cancel();
    if (_isCountingDown) {
      _isCountingDown = false;
      notifyListeners();
    }
  }

  void onStablePostureDetected() {
    // TODO: Implement what should happen when posture is stable for 3 seconds
    // debugPrint("Stable posture detected for 3 seconds!");
    // load to measure page let know that length and weight will be measured

    onStablePostureCallback?.call();
  }


  String get message => postureResponse[_postureId]?[0] ?? "Onbekende houding";
  String get imagePath =>
      postureResponse[_postureId]?[1] ?? "assets/images/feet-icon-default.png";

  @override
  void dispose() {
    _stabilityTimer?.cancel();
    super.dispose();
  }
  

  // Simulate posture changes for development purposes
  void simulatePostureChanges() {
    Future.delayed(const Duration(seconds: 1), () {
      updatePosture("4");
    });

    Future.delayed(const Duration(seconds: 3), () {
      updatePosture("1"); //links
    });

    Future.delayed(const Duration(seconds: 3), () {
      updatePosture("2");
    });

    Future.delayed(const Duration(seconds: 2), () {
      updatePosture("3");//links
    });

    Future.delayed(const Duration(seconds: 4), () {
      updatePosture("0");
    });
  }
}
