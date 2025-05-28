import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:collection/collection.dart';

class BluetoothServiceApp extends ChangeNotifier{

  bool get isConnected => specificDevice != null && writeCharacteristic != null && notifyCharacteristic != null;

  final Map<String, String> labels = {
    "0": "correct posture",
    "1": "inbalance left",
    "2": "inbalance right",
    "3": "on toes",
    "4": "wrong foot position",
  };

  final int _seconds = 5;

  Duration get duration => Duration(seconds:_seconds);

  final List<ScanResult> _scanResults = [];

  List<ScanResult> get scanResults => _scanResults;

  String dynamicLabel = "";
  BluetoothDevice? specificDevice;
  BluetoothService? specificService;
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  StreamSubscription<List<int>>? notifyCharacteristicSubscribtion;
  final String _specificAdvname = "MeasureMates";
  final String _specificServiceID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
  final String _specificCharacteristicNotifyID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
  final String _specificCharacteristicWriteID = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
  // final String _specificAdvname = "DZ Meetmat";
  // final String _specificServiceID = "1818";
  // final String _specificCharacteristicNotifyID = "2A63";
  // final String _specificCharacteristicWriteID = "2A66";

  Future<void> mainConnector() async {

    await FlutterBluePlus.adapterState.firstWhere((state) =>
    state == BluetoothAdapterState.on);

    bool foundDevice = await findBySpecificAdvname();
    print("\t\t\t\tmainConnector:- foundDevice: $foundDevice");

    if (foundDevice) {
      bool globallyConnected = await connectToSpecificDevice();
      print("\t\t\t\tmainConnector:- globallyConnected: $globallyConnected");

      if (globallyConnected) {
        bool serviceFound = await findSpecificService();
        print("\t\t\t\tmainConnector:- serviceFound: $serviceFound");

        if (serviceFound) {
          bool readFound = await findWriteCharacteristic();
          bool notifyFound = await findNotifyCharacteristic();
          print(
              "\t\t\t\tmainConnector:- readFound: $readFound, notifyFound: $notifyFound");

          if (readFound && notifyFound) {
            writeToDevice("CONNECTED");
            writeToDevice("START");

            print("\t\t\t\tmainConnector:- Ready, should try to open listeners");
            // await notifyCharacteristic!.setNotifyValue(true);
            // notifyCharacteristic!.onValueReceived.listen((value) {
            //   try {
            //     final valueList = decimalChanger(value);
            //
            //     print("${valueList[0]} ${valueList[1]} $dynamicLabel");
            //   } catch (e) {
            //     print("\t\t\t\tBluetoothViewModel: Skipped expression: $e");
            //   }
            //   // writeToDevice("APPROVED");
            //   // writeToDevice("DISAPPROVED");
            //   // print("\t\t\t\mainConnecter:- Requested new block");
            // });

          } else {
            print("\t\t\t\tmainConnector: a characteristic not found");
          }
        } else {
          print("\t\t\t\tmainConnector: no service found");
        }
      } else {
        print("\t\t\t\tmainConnector: no global connection");
      }
    } else {
      print("\t\t\t\tmainConnector: no device found");
    }
  }

  Future<bool> findBySpecificAdvname() async {
    try {
      bool activeCondition;
      print("\t\t\t\tBluetoothViewModel: Starting scanning for $_seconds seconds");
      await FlutterBluePlus.startScan(timeout: duration);

      FlutterBluePlus.startScan(timeout: duration);
      FlutterBluePlus.scanResults.listen((results) {
        _scanResults.clear();
        _scanResults.addAll(results);
        notifyListeners();
      });

      print("\t\t\t\tBluetoothViewModel: Searching for _specificAdvname");
      final activeScanResult = _scanResults.firstWhereOrNull(
              (scanResult) => scanResult.device.advName == _specificAdvname
      );

      if (activeScanResult != null) {
        specificDevice = activeScanResult.device;
        notifyListeners();
        activeCondition = true;
        FlutterBluePlus.stopScan();
      } else {
        print("\t\t\t\tBluetoothViewModel: activeScanResult is null");
        activeCondition = false;
      }
      return activeCondition;
    } catch (e) {
      print("\t\t\t\tBluetoothViewModel: Error in lookForSpecificAdvname: $e");
      return false;
    }
  }

  Future<bool> connectToSpecificDevice() async {
    try {
      final device = specificDevice;
      if (device == null) {
        print(
            "\t\t\t\tBluetoothViewModel: Did not try connecting because no specific device is set");
        return false;
      }

      print("\t\t\t\tBluetoothViewModel: Trying to connect to: $specificDevice");
      await device.connect(timeout: duration);
      device.connectionState.listen((event) {
        if (event == BluetoothConnectionState.connected) {
          print("\t\t\t\tBluetoothViewModel: Connected to: ${device
              .advName} on: ${device
              .platformName}");
        } else {
          print("\t\t\t\tBluetoothViewModel: ${event.toString()} from ${device
              .platformName}");
        }
      });
      return true;
    } catch (e) {
      print("\t\t\t\tBluetoothViewModel: Error in connectToSpecificDevice: $e");
      return false;
    }
  }

  Future<bool> findSpecificService() async {
    try {
      final device = specificDevice;
      if (device == null) {
        print("\t\t\t\tBluetoothViewModel: No specific device is set");
        return false;
      }
      print("\t\t\t\tBluetoothViewModel: Finding service");
      List<BluetoothService> services = await device.discoverServices();
      final activeService = services.firstWhereOrNull((service) =>
      service.uuid.toString() == _specificServiceID.toLowerCase());
      if (activeService == null) {
        print("\t\t\t\tBluetoothViewModel: Specific service not found");
        return false;
      }
      specificService = activeService;
      return true;
    } catch (e) {
      print("\t\t\t\tBluetoothViewModel: Error in findSpecificService: $e");
      return false;
    }
  }

  Future<bool> findWriteCharacteristic() async {
    try {
      final service = specificService;
      if (service == null) {
        print("\t\t\t\tBluetoothViewModel: No specific service is set");
        return false;
      }

      print("\t\t\t\tBluetoothViewModel: Finding characteristic");
      final activeCharacteristic = service.characteristics.firstWhereOrNull(
              (characteristic) =>
          characteristic.uuid.toString() ==
              _specificCharacteristicWriteID.toLowerCase()
      );
      if (activeCharacteristic == null) {
        print("\t\t\t\tBluetoothViewModel: Characteristic not found");
        return false;
      }
      writeCharacteristic = activeCharacteristic;
      return true;
    } catch (e) {
      print("\t\t\t\tBluetoothViewModel: Error in findWriteCharacteristic: $e");
      return false;
    }
  }

  Future<bool> findNotifyCharacteristic() async {
    try {
      final service = specificService;
      if (service == null) {
        print("\t\t\t\tBluetoothViewModel: No specific service is set");
        return false;
      }

      print("\t\t\t\tBluetoothViewModel: Finding characteristic");
      final activeCharacteristic = service.characteristics.firstWhereOrNull((
          characteristic) =>
      characteristic.uuid.toString() ==
          _specificCharacteristicNotifyID.toLowerCase());
      if (activeCharacteristic == null) {
        print("\t\t\t\tBluetoothViewModel: Characteristic not found");
        return false;
      }
      notifyCharacteristic = activeCharacteristic;
      return true;
    } catch (e) {
      print("\t\t\t\tBluetoothViewModel: Error in findNotifyCharacteristic: $e");
      return false;
    }
  }

  Future<void> writeToDevice(String text) async{
    List<int> textBytes = text.codeUnits;
    print("\t\t\t\tBluetoothViewModel: Sending data to characteristic: $textBytes");
    await writeCharacteristic!.write(textBytes, withoutResponse: false);
  }


  List<dynamic> decimalChanger(List<int> value) {
    final foot = String.fromCharCode(value[0]);

    final values = <int>[];

    // TODO length delen door 2
    for (int i = 0; i < 105; i++) {
      final high = value[1 + i * 2];
      final low = value[1 + i * 2 + 1];
      final num = (high << 8) | low;
      values.add(num);
    }
    // print("$foot values with length ${values.length}: $values");
    return [foot, values];
  }
}
