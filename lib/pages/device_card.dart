import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:zzsports/ble/ble_manager.dart';
import 'package:zzsports/model/core_body_temperature.dart';
import 'package:zzsports/model/health_thermometer.dart';
import 'package:zzsports/pages/device_setting.dart';
import '../model/temperature_unit.dart';

class DeviceDataController extends GetxController {
  final Rx<CoreBodyTemperature> coreTemperature = CoreBodyTemperature(
      coreTemperature: 0,
      hrmState: HRMState.unavailable,
      dataQuality: CBTQuality.unavailable,
      skinTemperature: 0,
      unit: TemperatureUnit.C).obs;
  
  final Rx<HealthTemperature> temperature = HealthTemperature(bodyTemperature: 0, unit: TemperatureUnit.C).obs;

  final RxList<int> batteryLevel = RxList([]);
  final String deviceId = BleManager().deviceId;

  void bindData() {
    final QualifiedCharacteristic coreTemperatureCharacteristic =
        QualifiedCharacteristic(
            characteristicId: Uuid.parse(characteristicCBTUuid),
            serviceId: Uuid.parse(serviceCBTSUuid),
            deviceId: deviceId);
    final QualifiedCharacteristic batteryLevelCharacteristic =
        QualifiedCharacteristic(
            characteristicId: Uuid.parse(characteristicBatteryLevelUuid),
            serviceId: Uuid.parse(serviceBatteryUuid),
            deviceId: deviceId);
    final QualifiedCharacteristic temperatureCharacteristic =
        QualifiedCharacteristic(
            characteristicId: Uuid.parse(characteristicTMUuid),
            serviceId: Uuid.parse(serviceHTSUuid),
            deviceId: deviceId);
    // BleManager().serviceDiscoverer.subScribeToCharacteristic(coreTemperatureCharacteristic).listen((event) { })
    coreTemperature.bindStream(BleManager()
        .serviceDiscoverer
        .subScribeToCharacteristic(coreTemperatureCharacteristic)
        .map(CoreBodyTemperature.instanceFromData)
    );
    batteryLevel.bindStream(BleManager()
        .serviceDiscoverer
        .subScribeToCharacteristic(batteryLevelCharacteristic));
    temperature.bindStream(BleManager()
        .serviceDiscoverer
        .subScribeToCharacteristic(temperatureCharacteristic)
        .map(HealthTemperature.instanceFromData)
    );
  }
}

class DeviceCard extends StatelessWidget {
  DeviceCard({super.key});

  final DeviceDataController dataController = Get.put(DeviceDataController());

  void onSettingPressed() {
    Get.to(const DeviceSetting());
  }

  @override
  Widget build(BuildContext context) {
    dataController.bindData();
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width - 20,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 2,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.orange,
                            child: Center(
                              child: Text(
                                "${dataController.temperature.value.bodyTemperature}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.orange,
                                    size: 10,
                                  ),
                                  Text("未佩戴"),
                                ],
                              ),
                              Text("Core"),
                              Text("请佩戴设备接收数据"),
                              // Add your content inside this Column
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: IconButton(
                              color: Colors.grey,
                              onPressed: onSettingPressed,
                              icon: const Icon(Icons.settings)),
                        ),
                      ],
                    ),
                  )),
              Row(
                children: [
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.bluetooth_audio,
                          size: 14,
                        ),
                        Icon(
                          Icons.battery_full,
                          size: 14,
                        ),
                        Icon(
                          Icons.cloud,
                          size: 14,
                        ),
                        Icon(
                          Icons.monitor_heart,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 130,
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Text 1'),
                        Text('Text 2'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
