import 'package:flutter/material.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:wonder/posture_check.dart';
import 'package:wonder/round_button.dart';

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



//Front end design
//FIXME: logic implement into frontend


class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  String? selectedDevice;

  void handleDeviceSelected(String device) {
    setState(() {
      selectedDevice = device;
    });
  }

  void disconnectDevice() {
    setState(() {
      selectedDevice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/bluethooth-icon.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 30),
            selectedDevice == null
                ? BluetoothSelect(onDeviceSelected: handleDeviceSelected)
                : BluetoothConnected(
              deviceName: selectedDevice!,
              onDisconnect: disconnectDevice,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Terug naar Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothSelect extends StatefulWidget {
  final void Function(String) onDeviceSelected;

  const BluetoothSelect({super.key, required this.onDeviceSelected});

  @override
  State<BluetoothSelect> createState() => _BluetoothSelectState();
}

class _BluetoothSelectState extends State<BluetoothSelect> {
  final List<String> availableDevices = [
    'Meetmat-001',
    'Meetmat-002',
    'Meetmat-003',
    'Meetmat-004',
    'Meetmat-005',
  ]; //replace with actual bluetooth devices data

  String? selectedDevice;

  void selectDevice(String deviceName) async {
    setState(() {
      selectedDevice = deviceName; // Highlight immediately
    });

    await Future.delayed(const Duration(seconds: 2));
    widget.onDeviceSelected(deviceName); // Notify parent after 2s
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        // color: Theme.of(context).colorScheme.primaryContainer,
        color: Color(0xFFE2E6EF),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        children: [
          Text(
            'Verbind met de meetmat',
            textAlign: TextAlign.center,
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Icon(Icons.bluetooth),
          //     const SizedBox(width: 10),
          //     Text(
          //       'Beschikbare apparaten',
          //       style: textTheme.titleMedium,
          //     ),
          //   ],
          // ),
          const SizedBox(height: 10),
          Container(
            width: 250,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              // shrinkWrap: true,
              itemCount: availableDevices.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final device = availableDevices[index];
                return ListTile(
                  title: Text(
                    device,
                    style: TextStyle(
                      color:
                      selectedDevice == device
                          ? Colors
                          .blue // Highlight selected item
                          : Colors.black, // Default color
                    ),
                  ),
                  trailing:
                  selectedDevice == device
                      ? CircularProgressIndicator(
                    value: null,
                    strokeWidth: 3.0,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF5382DE),
                    ),
                  )
                      : const Icon(Icons.add, color: Colors.grey),
                  onTap: () => selectDevice(device),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BluetoothConnected extends StatelessWidget {
  final String deviceName;
  final VoidCallback onDisconnect;

  const BluetoothConnected({
    super.key,
    required this.deviceName,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      constraints: BoxConstraints(
        maxHeight:
        MediaQuery.of(context).size.height * 0.4, // caps at 60% of screen
      ),
      decoration: BoxDecoration(
        color: Color(0xFFE2E6EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text('Verbonden met: $deviceName'),
              const SizedBox(height: 16),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // CircularProgressIndicator(
                    //   value: 0.7,
                    //   strokeWidth: 10.0,
                    //   backgroundColor: Colors.grey[300],
                    //   valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5382DE)),
                    // ),
                    _circularProgressWithText(percentage: 70, text: '70%'),
                    // Text(''),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    RoundButton(
                      name: 'Beginnen met meting',
                      onPresse: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PostureCheckPage(),
                          ),
                        );
                      },
                      color: Colors.blue[100],
                    ),
                    RoundButton(
                      name: 'Verbinding verbreken',
                      onPresse: onDisconnect,
                      color: Colors.blue[100],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _circularProgressWithText({required int percentage, String? text}) {
  var value = percentage / 100.0;
  var size = 80.0;

  text ??= '$percentage%';

  return Stack(
    alignment: AlignmentDirectional.center,
    children: <Widget>[
      Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(strokeWidth: 9, value: value),
        ),
      ),
      Center(child: Text(text)),
    ],
  );
}
