import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'ble_device_connector.dart';
import 'ble_device_interactor.dart';
import 'ble_logger.dart';
import 'ble_scanner.dart';
import 'ble_status_monitor.dart';

const String deviceIdKey = "ble_device_id";

class BleManager {
  static final BleManager _sharedInstance = BleManager._();

  factory BleManager() => _sharedInstance;

  BleManager._() {
    _bleLogger = BleLogger(ble: _ble);
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

  void connectDevice(String deviceId) {
    GetStorage().write(deviceIdKey, deviceId);
    connector.connect(deviceId);
  }

  String get deviceId {
    return GetStorage().read(deviceIdKey);
  }
}
