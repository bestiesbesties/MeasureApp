import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth/bluetooth_viewmodel.dart';
import 'package:wonder/homepage/homepage.dart';
import 'package:wonder/round_button.dart';

import 'bluetooth_service.dart';

class BluetoothView extends StatelessWidget {
  const BluetoothView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BluetoothViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/bluetooth-icon.png",
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              Container(
                width: 260,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                decoration: BoxDecoration(
                  color:  Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (viewModel.connectionState == "Connected")
                            Column(
                              children: viewModel.connectionTelemetry!.entries
                                  .map((entry) {
                                return Text("${entry.key} ${entry.value}");
                              }).toList(),
                            )

                          else if (viewModel.connectionState == "Connecting")
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                CircularProgressIndicator(
                                  strokeWidth: 6.0,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFF5382DE),
                                  ),
                                ),
                              ],
                            )

                          else if (viewModel.connectionState == "Failed")
                            Text("Verbinden mislukt")
                          else
                            const Text(
                              "Als de meetmat aan staat kun je hier verbinden...",
                            ),


                          const SizedBox(height: 8),
                          SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                RoundButton(
                                  name: "Verbinden",
                                  color: Colors.blue[100],
                                  onPressed: () {
                                    viewModel.tryConnecting();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              RoundButton(
                name: "Terug naar home",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangeNotifierProvider(
                        create:
                            (_) => BluetoothViewModel(
                          bluetoothServiceApp:
                          Provider.of<BluetoothServiceApp>(
                            context,
                            listen: true,
                          ),
                        ),
                        child: HomepageView(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
