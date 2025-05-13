import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'device_list_item.dart';
import 'package:zzsports/ble/ble_manager.dart';

class DeviceController extends GetxController {

  final RxList<DiscoveredDevice> devicesList = RxList<DiscoveredDevice>([]);

  void startScan() {
    BleManager().devices.listen((event) {devicesList.assignAll(event);});
    BleManager().startScanDevices();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    debugPrint("close page");
    BleManager().stopScanDevices();
    super.onClose();
  }
}

class DevicesListPage extends StatelessWidget {
  DevicesListPage({super.key});

  final deviceController = Get.put(DeviceController());

  void _onTapDevice(BuildContext context, DiscoveredDevice device) {
    BleManager().stopScanDevices();
    BleManager().connectDevice(device.id);
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
                  ...deviceController.devicesList.value
                      .map(
                        (device) => DeviceListItem(
                            device: device,
                            onTapAction: _onTapDevice,
                          )
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
