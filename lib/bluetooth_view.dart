import 'package:flutter/material.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
import 'package:provider/provider.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({super.key});

  @override
  Widget build(BuildContext context) {
    print("BluetoothView: Creating specific provider with current context ");
    final viewModel = Provider.of<BluetoothViewModel>(context);

    return  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  child: Center(
                      child: Text("Scan")
                  ),
                  onPressed: () {
                    print("BluetoothView: Tapped");
                    viewModel.startScan();
                    print("Result: ${viewModel.devices.toString()}");
                  }
              ),
              Text(viewModel.devices
                  .map((d) => '${d.publicName} (${d.platName})')
                  .join('\n\n '))

            ],
          ),
        ));
  }
}
