import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bluetooth_test/pages/home.dart';

import 'controllers/bluetooth_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothController>.value(
            value: BluetoothController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
        ),
        home: HomePage(),
      ),
    );
  }
}
