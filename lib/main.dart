import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zzsports/pages/main_page.dart';
import 'package:zzsports/service/http_service.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import 'ble/ble_device_connector.dart';
import 'ble/ble_device_interactor.dart';
import 'ble/ble_logger.dart';
import 'ble/ble_scanner.dart';
import 'ble/ble_status_monitor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initServices();
  runApp(const MyApp());
}

initServices() async {
  final ble = FlutterReactiveBle();
  final bleLogger = BleLogger(ble: ble);
  final scanner = BleScanner(ble: ble, logMessage: bleLogger.addToLog);
  final monitor = BleStatusMonitor(ble);
  final connector = BleDeviceConnector(
    ble: ble,
    logMessage: bleLogger.addToLog,
  );
  final serviceDiscoverer = BleDeviceInteractor(
    bleDiscoverServices: ble.discoverServices,
    readCharacteristic: ble.readCharacteristic,
    writeWithResponse: ble.writeCharacteristicWithResponse,
    writeWithOutResponse: ble.writeCharacteristicWithoutResponse,
    subscribeToCharacteristic: ble.subscribeToCharacteristic,
    logMessage: bleLogger.addToLog,
  );

  Get.put(ble);
  Get.put(bleLogger);
  Get.put(scanner);
  Get.put(monitor);
  Get.put(connector);
  Get.put(serviceDiscoverer);

  await Get.putAsync<HttpService>(
          () async => await HttpService().init(baseUrl: "http://www.xueyazhushou.com"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: MainPage());
  }
}