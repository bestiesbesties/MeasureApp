import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/homepage/homepage.dart';
import 'package:wonder/round_button.dart';

import '../bluetooth/bluetooth_service.dart';
import '../bluetooth/bluetooth_viewmodel.dart';

class MeasureAwait extends StatelessWidget {
  const MeasureAwait({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/feet-icon-default.png",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 30),
        Text(
          "Blijf even staan, de meting wordt uitgevoerd",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),

        // if still data is still in progress, show this indicator
        CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF5382DE)),
        ),
      ],
    );
  }
}

class MeasureSend extends StatelessWidget {
  const MeasureSend({super.key});

  //FIXME: this function only for simulation purposes
  int getRandomNumber() {
    // Simulate a random number for length and weight
    return (25 +
            (100 * (0.5 - (DateTime.now().millisecondsSinceEpoch % 100) / 100)))
        .toInt();
  }

  String getNextMeasurementDate() {
    final DateTime nextDate = DateTime.now().add(const Duration(days: 90));
    return "${nextDate.day.toString().padLeft(2, '0')}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/feet-icon-default.png",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 30),
        Text(
          "Dit zijn de resultaten van de meting",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Text(
          "Lengte: ${getRandomNumber()} cm\n Gewicht: ${getRandomNumber()} kg\n",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),

        const SizedBox(height: 10),
        Text(
          "Het volgende meting wordt verwacht op:\n ${getNextMeasurementDate()}",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class MeasureView extends StatefulWidget {
  const MeasureView({super.key});

  @override
  State<MeasureView> createState() => _MeasureViewState();
}

class _MeasureViewState extends State<MeasureView> {
  bool measureDone = false;

  //FIXME: this function is only for simulation purposes
  void toggleMeasureDone() {
    setState(() {
      measureDone = !measureDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !measureDone ? MeasureAwait() : MeasureSend(),
            const SizedBox(height: 10),

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
                ;
              },
            ),
            //FIXME: this button only for simulation purposes
            RoundButton(
              name:
                  measureDone ? "Simulatie reset" : "Simuleer meting voltooid",
              onPressed: () {
                toggleMeasureDone();
              },
            ),
          ],
        ),
      ),
    );
  }
}
