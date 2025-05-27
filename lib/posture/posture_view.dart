import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:wonder/bluetooth/bluetooth_view.dart';
import 'package:wonder/measure/measure_view.dart';
import 'package:wonder/posture/posture_viewmodel.dart';
import 'package:wonder/bluetooth/bluetooth_viewmodel.dart';
import 'package:wonder/round_button.dart';

class PostureView extends StatelessWidget {
  final String initialPostureId;

  const PostureView({super.key, required this.initialPostureId});

  @override
  Widget build(BuildContext context) {
    //FIXME: uncomment this in deployment to use bluetooth connection
    final bluetooth = Provider.of<BluetoothViewModel>(context);
    if (bluetooth.connectionState == "Failed"||bluetooth.connectionState == "Disconnected") {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Geen verbinding met maat."),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundButton(
                    name: "Maak verbinding",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ChangeNotifierProvider(
                            create:
                                (_) => BluetoothViewModel(
                              bluetoothServiceApp:
                              Provider.of<
                                  BluetoothServiceApp
                              >(context, listen: true),
                            ),
                            child: BluetoothView(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Precache all images before showing the posture screen
    return FutureBuilder(
      future: _precacheAllImages(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create:
                (_) => PostureViewModel(
                  initialPostureId, // get posture data
                  onStablePostureCallback: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MeasureView()),
                    );
                  },
                ),
            child: const _PostureScreen(),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<void> _precacheAllImages(BuildContext context) async {
    const imagePaths = [
      "assets/images/feet-icon-correct.png",
      "assets/images/feet-icon-wrong-left.png",
      "assets/images/feet-icon-wrong-right.png",
      "assets/images/feet-icon-wrong-toes.png",
      "assets/images/feet-icon-wrong-all.png",
      "assets/images/feet-icon-default.png",
    ];

    for (final path in imagePaths) {
      await precacheImage(AssetImage(path), context);
    }
  }
}

class _PostureScreen extends StatelessWidget {
  const _PostureScreen();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostureViewModel>();
    final size = MediaQuery.of(context).size;
    final double imageSize =
        (size.width > size.height ? size.height : size.width) * 0.7;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Image.asset(
                  viewModel.imagePath,
                  key: ValueKey(viewModel.imagePath),
                  // forces animation when path changes
                  width: imageSize,
                  height: imageSize,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                viewModel.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child:
                    viewModel.isCountingDown
                        ? Text(
                          "Blijf nog voor ${viewModel.countdown}s zo staan!",
                          key: const ValueKey("countdownText"),
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                        : const SizedBox(
                          key: ValueKey("emptyBox"),
                          height:
                              28, // Adjust to match height of the text above
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
