import 'package:bluetooth_test/controllers/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bluetooth = Provider.of<BluetoothController>(context);

    Future<void> _conectDialog(ScanResult item) async {
      bool isConnected = false;

      if (bluetooth.connectedDevice != null &&
          item.device.id == bluetooth.connectedDevice.id) {
        isConnected = true;
      }

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isConnected
                ? 'Desconectar dispositivo'
                : 'Conectar dispositivo'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(isConnected
                      ? 'Deseja desconectar esse dispositivo?'
                      : 'Deseja conectar com esse dispositivo?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              isConnected
                  ? FlatButton(
                      child: Text('Desconectar'),
                      color: Colors.red,
                      onPressed: () {
                        bluetooth.disconnect(item.device);
                        Navigator.of(context).pop();
                      },
                    )
                  : FlatButton(
                      child: Text('Conectar'),
                      color: Colors.green,
                      onPressed: () {
                        bluetooth.connect(item.device);
                        Navigator.of(context).pop();
                      },
                    ),
            ],
          );
        },
      );
    }

    IconButton _scanDevices() {
      return IconButton(
          icon: Icon(Icons.refresh),
          onPressed: bluetooth.isOn ? () => bluetooth.startScan() : null);
    }

    IconButton _stopScan() {
      return IconButton(
        icon: Icon(Icons.stop),
        onPressed: bluetooth.isOn ? () => bluetooth.stopScan() : null,
      );
    }

    AppBar _appBar() {
      return AppBar(
        title: Text('Bluetooth Flutter'),
        centerTitle: true,
        actions: <Widget>[bluetooth.isScanning ? _stopScan() : _scanDevices()],
      );
    }

    ListTile _listTile(ScanResult item) {
      bool isConnected = false;

      if (bluetooth.connectedDevice != null &&
          item.device.id == bluetooth.connectedDevice.id) {
        isConnected = true;
      }

      TextStyle _textStyle = isConnected
          ? TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.bold)
          : null;

      return ListTile(
        enabled: item.advertisementData.connectable,
        leading: Icon(
          Icons.devices_other,
          color: isConnected ? Theme.of(context).textSelectionColor : null,
        ),
        title: Text(
          item.device.name != '' ? item.device.name : 'Desconhecido',
          style: _textStyle,
        ),
        subtitle: Text(
          item.device.id.toString(),
          style: _textStyle,
        ),
        onTap: () => _conectDialog(item),
        // trailing: IconButton(
        //   icon: Icon(Icons.delete),
        //   onPressed: (bluetooth.isConnected &&
        //           bluetooth.connectedDevice.id == item.device.id)
        //       ? () => bluetooth.disconnect(item.device)
        //       : null,
        // ),
      );
    }

    Container _loader() {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 16),
        child: Center(
          child: SizedBox(
            width: 33,
            height: 33,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
        ),
      );
    }

    Column _homeBluetoothOff() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.bluetooth_disabled,
            size: 48,
          ),
          Text(
            'Ligue o bluetooth para utilizar o aplicativo.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          )
        ],
      );
    }

    ListView _homeBluetoothOn(
        BuildContext context, BluetoothController bluetooth) {
      return ListView.separated(
        itemCount: bluetooth.isScanning
            ? bluetooth.scanResults.length + 1
            : bluetooth.scanResults.length,
        itemBuilder: (context, index) {
          if (bluetooth.isScanning && index == bluetooth.scanResults.length) {
            return _loader();
          }
          var item = bluetooth.scanResults[index];
          return _listTile(item);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            height: 0,
          );
        },
      );
    }

    return Scaffold(
        appBar: _appBar(),
        body: bluetooth.isOn
            ? _homeBluetoothOn(context, bluetooth)
            : _homeBluetoothOff());
  }
}
