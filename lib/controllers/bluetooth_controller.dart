import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothController extends ChangeNotifier {
  bool isOn = false;
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  BluetoothDevice connectedDevice;
  // bool isConnected = false;

  BluetoothController() {
    FlutterBlue.instance.state.listen((currentState) {
      this.isOn = currentState == BluetoothState.on;

      if (this.isOn) {
        this.startScan();
      } else {
        this.scanResults = [];
      }

      notifyListeners();
    });

    FlutterBlue.instance.scanResults.listen((currentState) {
      this.scanResults = currentState;
      notifyListeners();
    });

    FlutterBlue.instance.isScanning.listen((currentState) {
      this.isScanning = currentState;
      notifyListeners();
    });
  }

  connect(BluetoothDevice device) {
    this.connectedDevice = device;
    device.connect();
    device.state.listen((onData) {
      print(onData.toString());
      // this.isConnected = onData == BluetoothDeviceState.connected;
    });
    notifyListeners();
  }

  disconnect(BluetoothDevice device) {
    device.disconnect();
    this.connectedDevice = null;
    notifyListeners();
  }

  startScan() {
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 5));
  }

  stopScan() {
    FlutterBlue.instance.stopScan();
  }
}
