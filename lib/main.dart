import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth_viewmodel.dart';
import 'package:wonder/bluetooth_view.dart';

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
        home: Scaffold(
            body: Center(child: BluetoothView())
        )
      );
  }
}
