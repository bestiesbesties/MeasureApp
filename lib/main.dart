import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wonder/bluetooth/bluetooth_service.dart';
import 'package:wonder/homepage/homepage.dart';
import 'package:wonder/webserver/webserver_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => WebserverService()),
      ChangeNotifierProvider(create: (_) => BluetoothServiceApp()),
      ChangeNotifierProvider(create: (_) => HomepageViewModel()),
    ],
    child: MaterialApp(
    home: HomepageView(),
      ),
    );
  }
}