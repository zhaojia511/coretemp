import 'dart:math';

import 'temperature_unit.dart';

class HealthTemperature {
  HealthTemperature({
    required this.bodyTemperature,
    required this.unit,
  });

  final double bodyTemperature;
  final TemperatureUnit unit;

  static HealthTemperature instanceFromData(List<int> data) {
    double bodyTemperature = 0;
    TemperatureUnit unit = TemperatureUnit.C;

    if (data.length == 5) {
      unit = TemperatureUnit.unitFromIndex((data[0] & 1)); //第一个字节的第0bit表示单位，0为摄氏度，1为华氏度

      int mantissa = data[2]*256*256+data[3]*256+data[4];
      int exponent = data[1];

      if (mantissa != 65535) {
        bodyTemperature = mantissa * pow(10, exponent) / 100.0;
      }
    }
    return HealthTemperature(bodyTemperature: bodyTemperature, unit: unit);
  }
}