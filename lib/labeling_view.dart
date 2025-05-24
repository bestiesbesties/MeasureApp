// import 'package:flutter/material.dart';
// import 'package:wonder/bluetooth/bluetooth_viewmodel.dart';
//
// class LabelingView extends StatelessWidget {
//   const LabelingView({required this.viewModel, super.key});
//   final BluetoothViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container (
//           padding: const EdgeInsets.only(top: 60.0, bottom: 60.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(bottom: 40.0),
//                 child: ElevatedButton(
//                   onPressed: () => viewModel.mainConnector(),
//                   child: Text("Verbind"),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     print("BluetoothView: Pressed: reset");
//                     viewModel.XdynamicLabel = "";
//                     viewModel.writeToDevice("DISAPPROVED");
//                   },
//                   child: Text("Reset meting"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: viewModel.labels.entries.map((entry) {
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 10.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     print("BluetoothView: Pressed: ${entry.value}");
//                     viewModel.XdynamicLabel = entry.value;
//                     viewModel.writeToDevice("DISAPPROVED");
//                   },
//                   child: Text(entry.value),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
//
