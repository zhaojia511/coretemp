import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:zzsports/ble/ble_manager.dart';
import 'package:zzsports/model/core_body_temperature.dart';
import 'package:zzsports/model/health_thermometer.dart';
import 'package:zzsports/pages/device_setting.dart';
import '../model/temperature.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DeviceDataController extends GetxController {
  final Rx<CoreBodyTemperature> coreTemperature = CoreBodyTemperature(
    coreTemperature: Temperature(unit: TemperatureUnit.C, value: 0),
    hrmState: HRMState.unavailable,
    dataQuality: CBTQuality.unavailable,
    skinTemperature: Temperature(unit: TemperatureUnit.C, value: 0),
  ).obs;

  final Rx<Temperature> healthTemperature =
      Temperature(value: 0, unit: TemperatureUnit.C).obs;

  final RxString batteryLevel = "".obs;
  final String deviceId = BleManager().deviceId;
  final RxList<ChartData> chartDataList = RxList([]);

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

    Stream<CoreBodyTemperature> coreTemperatureStream = BleManager()
        .serviceDiscoverer
        .subScribeToCharacteristic(coreTemperatureCharacteristic).
        map(CoreBodyTemperature.instanceFromData).distinct().asBroadcastStream();

    coreTemperature.bindStream(coreTemperatureStream);
    coreTemperatureStream.listen((event) {
      DateTime time = DateTime.fromMicrosecondsSinceEpoch(event.coreTemperature.timeStamp);
      double value = event.coreTemperature.value;
      debugPrint(event.coreTemperature.toString());
      if (value > 0) {
        chartDataList.add(ChartData(time, value));
      }
    });

    healthTemperature.bindStream(BleManager()
        .serviceDiscoverer
        .subScribeToCharacteristic(temperatureCharacteristic)
        .map(HealthTemperature.instanceFromData));

    BleManager()
        .serviceDiscoverer
        .readCharacteristic(batteryLevelCharacteristic)
        .then((value) {
      if (value.isNotEmpty) {
        batteryLevel.value = value[0].toString();
      }
    });
  }
}

class DeviceCard extends StatelessWidget {
  DeviceCard({super.key});

  final DeviceDataController dataController = Get.put(DeviceDataController());

  void onSettingPressed() {
    Get.to(DeviceSetting());
  }

  @override
  Widget build(BuildContext context) {
    dataController.bindData();
    return Column(
      children: [
        Container(
          height: 100,
          width: MediaQuery.of(context).size.width - 20,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
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
                                child: Obx(
                                  () => Text(
                                    dataController
                                        .coreTemperature.value.coreTemperature
                                        .toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 180,
                            child: Obx(() {
                              Temperature temperature =
                                  dataController.healthTemperature.value;
                              Temperature coreTemperature = dataController
                                  .coreTemperature.value.coreTemperature;
                              String stateString = "未佩戴";
                              String tipString = "请佩戴设备接收数据";
                              if (temperature.value > 0) {
                                if (coreTemperature.value > 0) {
                                  stateString = "接收数据中...";
                                  tipString = "正在接收数据...";
                                } else {
                                  stateString = "等待有效数据...";
                                  tipString = "正在接收数据...";
                                }
                              }

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.orange,
                                        size: 10,
                                      ),
                                      Text(stateString),
                                    ],
                                  ),
                                  const Text(
                                    "Core",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    tipString,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  // Add your content inside this Column
                                ],
                              );
                            }),
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
        Obx(() {
          return SfCartesianChart(
            backgroundColor: Colors.white,
            primaryXAxis: DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
            ),
            primaryYAxis: NumericAxis(
              interval: 1,
            ),
            series: <ChartSeries>[
              SplineSeries<ChartData, DateTime>(
                  dataSource: dataController.chartDataList.value,
                  // dataSource: [
                  //   ChartData(DateTime.parse("2023-09-05 16:51:29"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:30"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:31"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:32"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:33"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:34"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:35"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:36"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:37"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:38"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:39"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:40"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:41"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:42"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:43"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:44"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:45"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:46"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:47"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:48"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:49"), 37.0),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:50"), 37.1),
                  //   ChartData(DateTime.parse("2023-09-05 16:51:51"), 37.1),
                  // ],
                  splineType: SplineType.natural,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.value),
            ],
          );
        }),
      ],
    );
  }
}

class ChartData {
  ChartData(this.time, this.value);
  final DateTime time;
  final double value;
}
