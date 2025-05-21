import 'package:flutter/material.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
import 'package:provider/provider.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({super.key});
  @override
  Widget build(BuildContext context) {
    // print("BluetoothView: Reload current context");
    final Map<String, String> labels = {
      "0": "correct posture",
      "1": "inbalance left",
      "2": "inbalance right",
      "3": "on toes",
      "4": "wrong foot position",
    };
    final viewModel = Provider.of<BluetoothViewModel>(context);
    return Column(
      children: [
        Container (
          padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: ElevatedButton(
                  onPressed: () => viewModel.mainConnector(),
                  child: Text("Verbind"),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("BluetoothView: Pressed: reset");
                    viewModel.XdynamicLabel = "";
                    viewModel.writeToDevice("DISAPPROVED");
                  },
                  child: Text("Reset meting"),
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
                    viewModel.XdynamicLabel = entry.value;
                    viewModel.writeToDevice("DISAPPROVED");
                  },
                  child: Text(entry.value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
