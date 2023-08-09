import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'ble_device_connector.dart';
import 'ble_device_interactor.dart';
import 'ble_logger.dart';
import 'ble_scanner.dart';
import 'ble_status_monitor.dart';

class BleManager {
  BleManager._();

  // final _ble = FlutterReactiveBle();
  // final _bleLogger = BleLogger(ble: _ble);
  // final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
  // final _monitor = BleStatusMonitor(_ble);
  // final _connector = BleDeviceConnector(
  //   ble: _ble,
  //   logMessage: _bleLogger.addToLog,
  // );
  // final _serviceDiscoverer = BleDeviceInteractor(
  //   bleDiscoverServices: _ble.discoverServices,
  //   readCharacteristic: _ble.readCharacteristic,
  //   writeWithResponse: _ble.writeCharacteristicWithResponse,
  //   writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
  //   subscribeToCharacteristic: _ble.subscribeToCharacteristic,
  //   logMessage: _bleLogger.addToLog,
  // );
  //
  // Get.put(_ble);
  // Get.put(_bleLogger);
  // Get.put(_scanner);
  // Get.put(_monitor);
  // Get.put(_connector);
  // Get.put(_serviceDiscoverer);
}