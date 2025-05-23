import 'dart:convert';
import 'package:http/http.dart';
// import 'package:wonder/bluetooth_viewmodel.dart';

void main() => sendData();



void sendData() async {
  // final viewModel = BluetoothViewModel();

  // viewModel.lookBySpecificAdvname();
  //
  // viewModel.connectToSpecificDevice();

  final response = await post(
    Uri.parse("http://127.0.0.1:5000/predict"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'input': [
        0.483, 0.027, 0.762, 0.138, 0.611, 0.905, 0.044, 0.316, 0.859, 0.725,
        0.599, 0.173, 0.938, 0.287, 0.406, 0.687, 0.350, 0.092, 0.781, 0.219,
        0.660, 0.017, 0.513, 0.118, 0.999, 0.230, 0.804, 0.061, 0.449, 0.674
      ]
    }),
  );
  if (response.statusCode == 201) {
    print('WebserverViewModel: ${jsonDecode(response.body)}');
  } else {
    print('WebserverViewModel: ${response.statusCode}, ${response.headers}, ${response.body}');
  }
}
