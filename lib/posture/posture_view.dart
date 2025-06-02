import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:wonder/bluetooth/bluetooth_view.dart';
import 'package:wonder/bluetooth/bluetooth_viewmodel.dart';
import 'package:wonder/homepage/homepage.dart';
import 'package:wonder/measure/measure_view.dart';
import 'package:wonder/posture/posture_viewmodel.dart';
import 'package:wonder/round_button.dart';

class PostureView extends StatefulWidget {
  const PostureView({super.key});

  @override
  State<PostureView> createState() => _PostureViewState();
}

class _PostureViewState extends State<PostureView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<PostureViewModel>(context, listen: false);
      viewModel.mainMeasurer();
      // viewModel.setEventHandler();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostureViewModel>(context);
    final size = MediaQuery.of(context).size;
    final double imageSize =
        (size.width > size.height ? size.height : size.width) * 0.7;
    //FIXME: uncomment this in deployment to use bluetooth connection
    // final bluetoothServiceApp = Provider.of<BluetoothServiceApp>(context);
    if (!viewModel.isConnected) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Geen verbinding met mat."),
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
                                          Provider.of<BluetoothServiceApp>(
                                            context,
                                            listen: true,
                                          ),
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

    Future openDialog() => showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Terug naar menu"),
            content: const Text(
              "Weet je zeker dat je terug wilt gaan naar het menu?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Annuleren"),
              ),
              TextButton(
                onPressed: () {
                  viewModel.disposeListener();
                  Navigator.pushReplacement(
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
                            child: const HomepageView(),
                          ),
                    ),
                  );
                },
                child: const Text("Ja"),
              ),
            ],
          ),
    );

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

              SizedBox(
                height: imageSize, // same height for both states
                child: Center(
                  child:
                  viewModel.message == "Onbekende houding"
                      ? Transform.scale(
                    scale: 1.8,
                    child: const CircularProgressIndicator(
                      strokeWidth: 4.0,
                      backgroundColor: Color(0xFFECECEC),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF5382DE),
                      ),
                    ),
                  )
                      : Image.asset(
                    viewModel.imagePath,
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 30),
              Text(viewModel.message),

              const SizedBox(height: 15),
              if (viewModel.isTrackingCorrect)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    "Blijf nog voor ${3 - viewModel.correctStopwatch.elapsed.inSeconds}s zo staan!",
                    key: const ValueKey("countdownText"),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

              if (viewModel.isCorrectIndefinite)
                MeasureView(measurment: viewModel.measurementIndefinite,),

              // Text("Meting is succesvol afgerond"),
              const SizedBox(height: 30),

              RoundButton(
                name: "Terug naar menu",
                onPressed: () {
                  openDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}