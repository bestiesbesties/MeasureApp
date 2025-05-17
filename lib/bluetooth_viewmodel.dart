import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth_device.dart';
import 'dart:convert';

class BluetoothViewModel extends ChangeNotifier {
  final List<ScanResult> _scanResults = [];
  final int _seconds = 5;

  List<ScanResult> get scanResults => _scanResults;
  Duration get duration => Duration(seconds: this._seconds);

  Future<void> refreshScanResults() async {
    print("BluetoothViewModel: Starting scanning for ${this._seconds} seconds");
    FlutterBluePlus.startScan(timeout: duration);
    FlutterBluePlus.scanResults.listen((results) {
      _scanResults.clear();
      _scanResults.addAll(results);
      notifyListeners();
      for (var result in results) {
        print("BluetoothViewModel: Found device: ${result.device.platformName}");
      }
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    print("BluetoothViewModel: Trying to connect to: $device");
    await device.connect(timeout: duration);

    device.connectionState.listen((event) {
      if (event == BluetoothConnectionState.connected) {
        print("BluetoothViewModel: Connected to ${device.platformName}");
      } else {
        print("BluetoothViewModel: ${event.toString()} from ${device.platformName}");
      }
    });

    print("BluetoothViewModel: Parsing characteristics");
    // final practicalCharacteristics = [];
    print("BluetoothViewModel: Trying to get practical info");
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
          // print("characteristic: ${characteristic.uuid}, properties: ${characteristic.properties}");
          if (characteristic.uuid.toString() == "2a21") {
            // practicalCharacteristics.add(characteristic);
            print("BluetoothViewModel: characteristic: ${characteristic.uuid}, descriptors: ${characteristic.descriptors}, properties: ${characteristic.properties}");
            final data = await characteristic.read();
            print("BluetoothViewModel: Raw data: $data");
            String strData = utf8.decode(data);
            print("BluetoothViewModel: Casted data: $strData");
        }
      }
    }
  }
}
