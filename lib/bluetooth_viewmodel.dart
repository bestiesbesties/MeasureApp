import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth_device.dart';

class BluetoothViewModel extends ChangeNotifier{
  List<BluetoothDeviceModel> devices = [];
  BluetoothDevice? activedevice;

  void startScan() {
    print("BluetoothViewModel: Starting scanning for 10 seconds");
    devices.clear();
    FlutterBluePlus.startScan(timeout:Duration(seconds: 10));
    print("scanresults: ${FlutterBluePlus.scanResults}");
    FlutterBluePlus.scanResults.listen( (onData) {
      print("$onData");
      print("BluetoothViewModel: Amt of catched open connections: ${onData.length}");
      for (ScanResult sr in onData) {
        final srDevice = sr.device;
        print("BluetoothViewModel: checking catched device");
        final condition = (srDevice.platformName.isNotEmpty &&
            !devices.any((device) => device.bluetoothDeviceRemoteId == srDevice.remoteId.str)
        );
        print("BluetoothViewModel: Condition to add device is: $condition");
        if (condition) {
          devices.add(BluetoothDeviceModel(
              publicName : srDevice.advName,
              platName: srDevice.platformName,
              bluetoothDeviceRemoteId: srDevice.remoteId.str

          )
          );
        }
        notifyListeners();
      }
    });
  }
}
