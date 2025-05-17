import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDeviceModel{
  final String publicName;
  final String platName;
  final String bluetoothDeviceRemoteId;
  final BluetoothDevice device;

  BluetoothDeviceModel({
    required this.publicName,
    required this.platName,
    required this.bluetoothDeviceRemoteId,
    required this.device
});
}
