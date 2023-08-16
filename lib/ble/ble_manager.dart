import 'dart:core';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_storage/get_storage.dart';
import 'ble_device_connector.dart';
import 'ble_device_interactor.dart';
import 'ble_logger.dart';
import 'ble_scanner.dart';
import 'ble_status_monitor.dart';

const String deviceIdKey = "ble_device_id";

const String serviceCBTSUuid = "00002100-5B1E-4347-B07C-97B514DAE121"; //Core Body Temperature Service;
const String serviceHTSUuid = "1809"; //Health Temperature Service;
const String serviceDeviceInformationUuid = "180A";
const String serviceBatteryUuid = "180F";

const String characteristicCBTUuid = "00002101-5B1E-4347-B07C-97B514DAE121";
const String characteristicTMUuid = "2a1c";
const String characteristicBatteryLevelUuid = "2a19";

class BleManager {
  static final BleManager _sharedInstance = BleManager._();

  factory BleManager() => _sharedInstance;

  BleManager._() {
    _bleLogger = BleLogger(ble: _ble);
    // if (deviceId.isNotEmpty) {
    //   connectDevice(deviceId);
    // }
  }

  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late BleLogger _bleLogger;
  BleScanner? _scanner;
  BleStatusMonitor? _monitor;
  BleDeviceConnector? _connector;
  BleDeviceInteractor? _serviceDiscoverer;

  FlutterReactiveBle get ble => _ble;

  BleScanner get scanner {
    _scanner ??= BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    return _scanner!;
  }

  BleStatusMonitor get monitor {
    _monitor ??= BleStatusMonitor(_ble);
    return _monitor!;
  }

  BleDeviceConnector get connector {
    _connector ??=
        BleDeviceConnector(ble: _ble, logMessage: _bleLogger.addToLog);
    return _connector!;
  }

  BleDeviceInteractor get serviceDiscoverer {
    _serviceDiscoverer ??= BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );
    return _serviceDiscoverer!;
  }

  void initialize() {
    // Get.put(_ble);
    // Get.put(_bleLogger);
    // Get.put(_scanner);
    // Get.put(_monitor);
    // Get.put(_connector);
    // Get.put(_serviceDiscoverer);
  }

  Future<void> connectDevice(String deviceId) async {
    GetStorage().write(deviceIdKey, deviceId);
    await connector.connect(deviceId);
  }

  String get deviceId {
    return GetStorage().read(deviceIdKey);
  }
}
