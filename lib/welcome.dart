import 'package:flutter/material.dart';
import 'package:wonder/bluetooth_view.dart';
import 'package:wonder/guide_before.dart';
import 'package:wonder/round_button.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: WelcomePage(),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool showOverlay = false;

  void toggleOverlay() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final TextTheme textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welkom, zijn jullie klaar om te meten?',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundButton(
                    name: 'Begin met meting',
                    onPresse: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BluetoothPage(),//??
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundButton(
                    name: 'Bekijk voorbereiding instructie',
                    onPresse: toggleOverlay,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showOverlay)
          Center(
            child: Container(
              height: height * 0.8,
              width: width * 0.8,
              child: Material(
                color: Colors.white,
                elevation: 10,
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    const TutorialBefore(),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: toggleOverlay,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
