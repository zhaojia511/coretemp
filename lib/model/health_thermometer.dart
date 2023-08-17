import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'temperature_unit.dart';

class HealthTemperature {
  HealthTemperature({
    required this.bodyTemperature,
    required this.unit,
  });

  final double bodyTemperature;
  final TemperatureUnit unit;

  static HealthTemperature instanceFromData(List<int> data) {
    debugPrint("$data");

    double bodyTemperature = 0;
    TemperatureUnit unit = TemperatureUnit.C;

    if (data.length == 5) {
      unit = TemperatureUnit.unitFromIndex((data[4] & 1)); //第一个字节的第0bit表示单位，0为摄氏度，1为华氏度

      int mantissa = data[3]*256*256+data[2]*256+data[1];
      int exponent = data[0];

      if (mantissa != 65535) {
        bodyTemperature = mantissa * pow(10, exponent) / 100.0;
      }
    }
    return HealthTemperature(bodyTemperature: bodyTemperature, unit: unit);
  }
}