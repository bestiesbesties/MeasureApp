import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
// import 'package:wonder/bluetooth_view.dart';
import 'package:wonder/welcome.dart';

void main() {

  runApp(ChangeNotifierProvider(
      create: (_) => BluetoothViewModel(),
      child: MainTreeObject()
  ));
}

class MainTreeObject extends StatelessWidget{
  const MainTreeObject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Measure App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1D53BF),
          ),
        ),
        home: Scaffold(
            // body: Center(child: BluetoothView())
            body: Center(child: MyHomePage())
        )
      );
  }
}
