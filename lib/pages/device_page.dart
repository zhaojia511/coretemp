// device_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zzsports/pages/devices_list_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'device_card.dart';

typedef OnTapAction = Function(BuildContext context);

class AddDeviceCard extends StatelessWidget {
  const AddDeviceCard({
    super.key,
    required this.onTapAction,
  });

  final OnTapAction onTapAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), // 设置圆角半径
            ),
            margin: const EdgeInsets.all(10),
            child: GestureDetector(
                onTap: () => onTapAction(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Image.asset("assets/device.png"),
                      Expanded(
                        child: Container(
                          color: Colors.green[500],
                          padding: EdgeInsets.all(10),
                          child: const Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Connect to your",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Core",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))));
  }
}

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  Future<void> _onAddDevicePressed(BuildContext context) async {
    var status = await Permission.bluetooth.status;
    if (status == PermissionStatus.granted) {
      Get.to(DevicesListPage());
    } else {
      openAppSettings();
      Get.defaultDialog(middleText: "连接设备需要打开蓝牙权限", cancel: const Text("OK"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设备'),
      ),
      body: Material(
        color: Colors.grey,
        child: Column(
          children: [
            AddDeviceCard(onTapAction: _onAddDevicePressed),
            DeviceCard(),
          ],
        ),
      ),
    );
  }
}
