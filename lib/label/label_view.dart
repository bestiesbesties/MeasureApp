import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:provider/provider.dart';
import 'package:wonder/webserver/webserver_service.dart';
import 'package:wonder/round_button.dart';

class LabelViewModel extends ChangeNotifier {
  final BluetoothServiceApp bluetoothServiceApp;
  final WebserverService webserverService;
  LabelViewModel({
    required this.bluetoothServiceApp,
    required this.webserverService
  });

  BluetoothDevice? get connectedDevice => bluetoothServiceApp.specificDevice;
  String dynamicTarget = "";
  List<List<dynamic>> buffer = [];
  int listenerLength = 0;

  void setListener() async {

    // print("\t\t\t\tLabelViewModel: Sending start");
    // writeToDevice("CONNECTED");
    // writeToDevice("START");

    print("\t\t\t\tLabelViewModel: Opening listener");
    if (bluetoothServiceApp.notifyCharacteristic != null) {
      await bluetoothServiceApp.notifyCharacteristic!.setNotifyValue(true);
      bluetoothServiceApp.notifyCharacteristicSubscribtion=  bluetoothServiceApp.notifyCharacteristic!.onValueReceived.listen((value) {
        print("\t\t\t\tLabelViewModel: Recieved a value (amt): $listenerLength");
        // listenerLength++;
        // if (listenerLength > 2) {
          try {
            final valueList = bluetoothServiceApp.decimalChanger(value);
            buffer.add(valueList[1]);
            print("\t\t\t\tLabelViewModel: Buffered foot: ${valueList[0]}");
            if (buffer.length == 2) {
              final flatList = buffer.expand((x) => x).toList();
              print("\t\t\t\tLabelViewModel: sending flattend buffer");
              webserverService.sendData(values: flatList, target: dynamicTarget);
              buffer.clear();
            }

            // print("${valueList[0]} ${valueList[1]} $dynamicLabel");
          } catch (e) {
            print("\t\t\t\tLabelViewModel: Error at setListener: $e");
          }
          // writeToDevice("APPROVED");
          // writeToDevice("DISAPPROVED");
          // print("\t\t\t\mainConnecter:- Requested new block");
        // }


      });
    } else {
      print("\t\t\t\tLabelViewModel: Error while opening listener: No global notifyCharacteristic");
    }

  // }

  // void writeToDevice(String text) async {
  //   try {
  //     List<int> textBytes = text.codeUnits;
  //     print("\t\t\t\tLabelViewModel: Sending data to characteristic: $textBytes");
  //     await bluetoothServiceApp.writeCharacteristic!.write(textBytes, withoutResponse: false);
  //   } catch (e) {
  //     print("\t\t\t\tLabelViewModel: Error at writeToDevice: $e");
  //   }

  }

  void disposeListener() {
    try {
      print("LabelViewModel: Cancelling listener");
      bluetoothServiceApp.notifyCharacteristicSubscribtion!.cancel();
      bluetoothServiceApp.notifyCharacteristicSubscribtion = null;
    } catch (e) {
      print("\t\t\t\tLabelViewModel: Error at disposeListener: $e");
    }
  }
}

class LabelView extends StatelessWidget {
  const LabelView({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, String> labels = {
      "0": "correct_posture",
      "1": "inbalance_left",
      "2": "inbalance_right",
      "3": "on_toes",
      "4": "wrong_foot_position",
    };
    final viewModel = Provider.of<LabelViewModel>(context);
    viewModel.setListener();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(viewModel.connectedDevice?.advName.toString() ?? "No devide connected"),
            Container (
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print("BluetoothView: Pressed: reset");
                        viewModel.dynamicTarget = "";
                        viewModel.bluetoothServiceApp.writeToDevice("DISAPPROVED");
                      },
                      child: Text("Lege meting"),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: labels.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print("BluetoothView: Pressed: ${entry.value}");
                        viewModel.dynamicTarget = entry.value;
                        viewModel.bluetoothServiceApp.writeToDevice("DISAPPROVED");
                      },
                      child: Text(entry.value),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            RoundButton(
              name: "Terug naar Home",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}