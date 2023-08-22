import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get_storage/get_storage.dart';
import 'ble_device_connector.dart';
import 'ble_device_interactor.dart';
import 'ble_logger.dart';
import 'ble_scanner.dart';
import 'ble_status_monitor.dart';

const String deviceIdKey = "ble_device_id";

const String serviceOldPrivateUuid = "00004200-F366-40B2-AC37-70CCE0AA83B1";

const String serviceCBTSUuid = "00002100-5B1E-4347-B07C-97B514DAE121"; //Core Body Temperature Service;
const String serviceHTSUuid = "1809"; //Health Temperature Service;
const String serviceDeviceInformationUuid = "180A";
const String serviceBatteryUuid = "180F";

const String characteristicCBTUuid = "00002101-5B1E-4347-B07C-97B514DAE121";
const String characteristicTMUuid = "2A1C";
const String characteristicBatteryLevelUuid = "2A19";

class BleManager {
  static final BleManager _sharedInstance = BleManager._();

  factory BleManager() => _sharedInstance;

  BleManager._() {
    _bleLogger = BleLogger(ble: _ble);
    if (deviceId.isNotEmpty) {
      debugPrint(deviceId);
      connectSavedDevice(deviceId);
    }
  }

  final FlutterReactiveBle _ble = FlutterReactiveBle();
  late BleLogger _bleLogger;
  BleScanner? _scanner;
  BleStatusMonitor? _monitor;
  BleDeviceConnector? _connector;
  BleDeviceInteractor? _serviceDiscoverer;
  Stream<List<DiscoveredDevice>>? _devices;

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

  List<Uuid> get services {
    return [Uuid.parse(serviceCBTSUuid),Uuid.parse(serviceOldPrivateUuid),];
  }

  Stream<List<DiscoveredDevice>> get devices {
    _devices ??= scanner.state.map((event) => event.discoveredDevices).asBroadcastStream();
    return _devices!;
  }

  void startScanDevices() {
    scanner.startScan(services);
  }

  void stopScanDevices() {
    scanner.stopScan();
  }

  Future<void> connectDevice(String deviceId) async {
    GetStorage().write(deviceIdKey, deviceId);
    await connector.connect(deviceId);
  }

  void connectSavedDevice(String deviceId) {
    ble.connectToAdvertisingDevice(id: deviceId, withServices: services, prescanDuration: const Duration(seconds: 100));
  }

  String get deviceId {
    return GetStorage().read(deviceIdKey);
  }
}
