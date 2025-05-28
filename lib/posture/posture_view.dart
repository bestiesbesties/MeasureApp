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
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PostureViewModel>(context);
    final size = MediaQuery.of(context).size;
    final double imageSize =
        (size.width > size.height ? size.height : size.width) * 0.7;

    //FIXME: uncomment this in deployment to use bluetooth connection
    final bluetooth = Provider.of<BluetoothViewModel>(context);
    if (bluetooth.connectionState == "Failed" ||
        bluetooth.connectionState == "Disconnected") {
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
              Image.asset(
                viewModel.imagePath,
                width: imageSize,
                height: imageSize,
              ),
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

              if (viewModel.isCorrectIndefinite) MeasureView(),

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

//FIXME: old version with simulation
// class PostureView extends StatelessWidget {
//   final String initialPostureId;
//
//   const PostureView({super.key, required this.initialPostureId});
//
//   @override
//   Widget build(BuildContext context) {
//     //FIXME: uncomment this in deployment to use bluetooth connection
//     // final bluetooth = Provider.of<BluetoothViewModel>(context);
//     // if (bluetooth.connectionState == "Failed"||bluetooth.connectionState == "Disconnected") {
//     //   return Scaffold(
//     //     body: Center(
//     //       child: Column(
//     //         mainAxisAlignment: MainAxisAlignment.center,
//     //         children: [
//     //           Text("Geen verbinding met mat."),
//     //           Row(
//     //             mainAxisSize: MainAxisSize.min,
//     //             children: [
//     //               RoundButton(
//     //                 name: "Maak verbinding",
//     //                 onPressed: () {
//     //                   Navigator.push(
//     //                     context,
//     //                     MaterialPageRoute(
//     //                       builder:
//     //                           (context) => ChangeNotifierProvider(
//     //                         create:
//     //                             (_) => BluetoothViewModel(
//     //                           bluetoothServiceApp:
//     //                           Provider.of<
//     //                               BluetoothServiceApp
//     //                           >(context, listen: true),
//     //                         ),
//     //                         child: BluetoothView(),
//     //                       ),
//     //                     ),
//     //                   );
//     //                 },
//     //               ),
//     //             ],
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //   );
//     // }
//
//     // Precache all images before showing the posture screen
//     return FutureBuilder(
//       future: _precacheAllImages(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return ChangeNotifierProvider(
//             create:
//                 (_) => PostureViewModel(
//                   initialPostureId, // get posture data
//                   onStablePostureCallback: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const MeasureView()),
//                     );
//                   },
//                 ),
//             child: const _PostureScreen(),
//           );
//         } else {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//       },
//     );
//   }
//
//   //FIXME: add assets if needed
//   Future<void> _precacheAllImages(BuildContext context) async {
//     const imagePaths = [
//       "assets/images/feet-icon-correct.png",
//       "assets/images/feet-icon-wrong-left.png",
//       "assets/images/feet-icon-wrong-right.png",
//       "assets/images/feet-icon-wrong-toes.png",
//       "assets/images/feet-icon-wrong-all.png",
//       "assets/images/feet-icon-default.png",
//     ];
//
//     for (final path in imagePaths) {
//       await precacheImage(AssetImage(path), context);
//     }
//   }
// }
//
// class _PostureScreen extends StatelessWidget {
//   const _PostureScreen();
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<PostureViewModel>();
//     final size = MediaQuery.of(context).size;
//     final double imageSize =
//         (size.width > size.height ? size.height : size.width) * 0.7;
//
//     //Funciton show dialog to confirm navigation back to the menu
//     Future openDialog() => showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//         title: const Text("Terug naar menu"),
//         content: const Text(
//           "Weet je zeker dat je terug wilt gaan naar het menu?",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Annuleren"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder:
//                       (context) => ChangeNotifierProvider(
//                     create:
//                         (_) => BluetoothViewModel(
//                       bluetoothServiceApp:
//                       Provider.of<BluetoothServiceApp>(
//                         context,
//                         listen: true,
//                       ),
//                     ),
//                     child: const HomepageView(),
//                   ),
//                 ),
//               );
//             },
//             child: const Text("Ja"),
//           ),
//         ],
//       ),
//     );
//
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 350),
//                 transitionBuilder: (child, animation) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//                 child: Image.asset(
//                   viewModel.imagePath,
//                   key: ValueKey(viewModel.imagePath),
//                   // forces animation when path changes
//                   width: imageSize,
//                   height: imageSize,
//                 ),
//               ),
//
//               const SizedBox(height: 30),
//
//               Text(
//                 viewModel.message,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//
//               AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 550),
//                 child:
//                     viewModel.isCountingDown
//                         ? Text(
//                           "Blijf nog voor ${viewModel.countdown}s zo staan!",
//                           key: const ValueKey("countdownText"),
//                           style: Theme.of(context).textTheme.titleLarge,
//                         )
//                         : const SizedBox(
//                           key: ValueKey("emptyBox"),
//                           height:
//                               28, // Adjust to match height of the text above
//                         ),
//               ),
//               RoundButton(
//                 name: "Terug naar menu",
//                 onPressed: () {
//                   openDialog();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
