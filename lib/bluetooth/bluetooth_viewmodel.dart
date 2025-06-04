import 'package:flutter/material.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';

class BluetoothViewModel extends ChangeNotifier {
  final BluetoothServiceApp bluetoothServiceApp;
  BluetoothViewModel({required this.bluetoothServiceApp});

  String connectionState = "Disconnected";
  Map<String, String>? connectionTelemetry;

  void tryConnecting() async {
    try {
      bluetoothServiceApp.checkPermissions();
      connectionState = "Connecting";
      notifyListeners();
      await bluetoothServiceApp.mainConnector();

      if (bluetoothServiceApp.specificDevice?.isConnected ?? false) {
        connectionState = "Connected";
        connectionTelemetry = {};
        connectionTelemetry!["Verbonden met"] = bluetoothServiceApp.specificDevice!.advName;
        connectionTelemetry!["Service"] = (bluetoothServiceApp.specificService != null).toString();
        connectionTelemetry!["Write"] = (bluetoothServiceApp.writeCharacteristic != null).toString();
        connectionTelemetry!["Notify"] = (bluetoothServiceApp.notifyCharacteristic != null).toString();
        notifyListeners();
      } else {
        connectionState = "Failed";
        notifyListeners();
      }

    } catch (e) {
      print("BluetoothViewModel: Error in tryConnecting: $e");
      connectionState = "Failed";
      notifyListeners();
    }
  }
}
