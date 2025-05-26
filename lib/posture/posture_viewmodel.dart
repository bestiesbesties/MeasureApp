import 'dart:async';
import 'package:flutter/material.dart';

class PostureViewModel extends ChangeNotifier {
  String _postureId;
  String get postureId => _postureId;

  final Map<String, List<String>> postureResponse = {
    "0": ["Je staat goed!", "assets/images/feet-icon-correct.png"],
    "1": [
      "Je staat te veel in balans naar links",
      "assets/images/feet-icon-wrong-left.png",
    ],
    "2": [
      "Je staat te veel in balans naar rechts",
      "assets/images/feet-icon-wrong-right.png",
    ],
    "3": ["Je staat op de tenen", "assets/images/feet-icon-wrong-toes.png"],
    "4": [
      "Je staat op verkeerde voetpositie",
      "assets/images/feet-icon-wrong-all.png",
    ],
  };

  Timer? _stabilityTimer;
  int _countdown = 3;
  int get countdown => _countdown;

  bool _isCountingDown = false;
  bool get isCountingDown => _isCountingDown;

  PostureViewModel(this._postureId) {
    simulatePostureChanges();
  }

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

  void _cancelCountdown() {
    _stabilityTimer?.cancel();
    if (_isCountingDown) {
      _isCountingDown = false;
      notifyListeners();
    }
  }

  void onStablePostureDetected() {
    // TODO: Implement what should happen when posture is stable for 3 seconds
    debugPrint("Stable posture detected for 3 seconds!");
  }

  String get message => postureResponse[_postureId]?[0] ?? "Onbekende houding";
  String get imagePath =>
      postureResponse[_postureId]?[1] ?? "assets/images/default.png";

  @override
  void dispose() {
    _stabilityTimer?.cancel();
    super.dispose();
  }
  

  void simulatePostureChanges() {
    Future.delayed(const Duration(seconds: 2), () {
      updatePosture("0");
    });

    Future.delayed(const Duration(seconds: 2), () {
      updatePosture("1"); //links
    });

    Future.delayed(const Duration(seconds: 2), () {
      updatePosture("0");
    });

    Future.delayed(const Duration(seconds: 2), () {
      updatePosture("2");//links
    });

    Future.delayed(const Duration(seconds: 4), () {
      updatePosture("0");
    });
  }
}
