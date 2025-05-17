import 'package:flutter/material.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
import 'package:provider/provider.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({super.key});

  @override
  Widget build(BuildContext context) {
    print("BluetoothView: Creating specific provider with current context ");
    final viewModel = Provider.of<BluetoothViewModel>(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0),
            child: Text("${viewModel.scanResults.length} apparaten gevonden.")
          ),
          Expanded(
            child: viewModel.scanResults.isNotEmpty
                ? ListView.builder(
                  itemCount: viewModel.scanResults.length,
                  itemBuilder: (context, index) {
                    final data = viewModel.scanResults[index];
                    return Card(
                      child: ListTile(
                        title: Text("${data.device.advName} \n ${data.device.platformName}"),
                        subtitle: Text(data.device.remoteId.toString()),
                        trailing: Text(data.rssi.toString()),
                        onTap: () => viewModel.connectToDevice(data.device),
                      ),
                    );
                  },
                )
                : Center(child: Text("Geen apparaten gevonden.")), // Geen return nodig
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 40.0), // Voeg verticale padding toe
            child: ElevatedButton(
              onPressed: () => viewModel.refreshScanResults(),
              child: Text("Scan apparaten"),
            )
          ),

        ],
      ),
    );
  }
}
