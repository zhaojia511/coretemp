import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zzsports/ble/ble_scanner.dart';
import 'device_list_item.dart';
import 'package:zzsports/ble/ble_manager.dart';

class DeviceController extends GetxController {
  final scanner = BleManager().scanner;
  final Rx<BleScannerState> scannerState =
      Rx<BleScannerState>(const BleScannerState(
    discoveredDevices: [],
    scanIsInProgress: false,
  ));

  StreamSubscription? _subscription;

  void startScan() {
    _subscription ??= scanner.state.listen((data) {
      scannerState.value = data;
    });
    scanner.startScan([Uuid.parse('00002100-5B1E-4347-B07C-97B514DAE121'), Uuid.parse('00004200-F366-40B2-AC37-70CCE0AA83B1')]);
  }

  void stopScan() {
    // _subscription?.cancel();
    scanner.stopScan();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    stopScan();
    super.onClose();
  }

  void connectDevice(String deviceId) {
    stopScan();
    BleManager().connectDevice(deviceId);
  }
}

class DevicesListPage extends StatelessWidget {
  DevicesListPage({super.key});

  final deviceController = Get.put(DeviceController());

  void _onTapDevice(BuildContext context, DiscoveredDevice device) {
    deviceController.connectDevice(device.id);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    deviceController.startScan();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          '蓝牙设备',
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Align(
              alignment: AlignmentDirectional(-1, -1),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                child: Text(
                  '添加Core设备',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Obx(
              () => ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  ...deviceController.scannerState.value.discoveredDevices
                      .map(
                        (device) => DeviceListItem(
                          device: device,
                          onTapAction: _onTapDevice,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextButton(
                onPressed: () {
                  deviceController.startScan();
                },
                child: const Text('重新扫描'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
