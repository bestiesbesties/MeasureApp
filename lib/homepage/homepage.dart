import 'package:flutter/material.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:wonder/label/label_view.dart';
import 'package:wonder/round_button.dart';
import 'package:provider/provider.dart';
import 'package:wonder/posture/posture_view.dart';
import 'package:wonder/bluetooth/bluetooth_viewmodel.dart';
import 'package:wonder/bluetooth/bluetooth_view.dart';
import 'package:wonder/homepage/homepage_overlay_view.dart';
import 'package:wonder/webserver/webserver_service.dart';
import 'package:wonder/webserver/webserver_view.dart';
import 'package:wonder/webserver/webserver_viewmodel.dart';

class HomepageViewModel extends ChangeNotifier{
  bool showOverlay = false;

  void toggleOverlay() {
    showOverlay = !showOverlay;
    notifyListeners();
  }
}

class HomepageView extends StatelessWidget {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final viewModel = Provider.of<HomepageViewModel>(context);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: Stack(
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
                              name: "Start meting",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => BluetoothViewModel(
                                          bluetoothServiceApp: Provider.of<BluetoothServiceApp>(context, listen: true)),
                                      child: PostureView(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundButton(
                              name: "Verzamel data",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => LabelViewModel(
                                          bluetoothServiceApp: Provider.of<BluetoothServiceApp>(context, listen: true),
                                          webserverService: Provider.of<WebserverService>(context, listen: true)
                                      ),
                                      child: LabelView(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundButton(
                              name: "Bluetooth",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => BluetoothViewModel(
                                          bluetoothServiceApp: Provider.of<BluetoothServiceApp>(context, listen: true)),
                                      child: BluetoothView(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundButton(
                              name: "Webserver",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => WebserverViewModel(
                                          webserverService: Provider.of<WebserverService>(context, listen: true)),
                                      child: WebserverView(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RoundButton(
                              name: 'Bekijk instructies',
                              onPressed: viewModel.toggleOverlay,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (viewModel.showOverlay)
                    HomepageOverlayView(viewModel: viewModel, height: height, width: width)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class HomepageNavigationButtonView extends StatelessWidget {
//   const HomepageNavigationButtonView({
//     this.service, required this.text, required this.create, required this.child, super.key});
//   final dynamic service;
//   final String text;
//   final ChangeNotifier Function(ChangeNotifier service) create;
//   final StatelessWidget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         RoundButton(
//           name: text,
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChangeNotifierProvider(
//                   create: (_) => create(service!),
//                   child: child,
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
