import 'dart:math';
import 'temperature.dart';

extension HealthTemperature on Temperature  {
  static Temperature instanceFromData(List<int> data) {
    double bodyTemperatureValue = 0;
    TemperatureUnit unit = TemperatureUnit.C;

    if (data.length == 5) {
      unit = TemperatureUnit.unitFromIndex((data[4] & 1)); //第一个字节的第0bit表示单位，0为摄氏度，1为华氏度

      int mantissa = data[3]*256*256+data[2]*256+data[1];
      int exponent = data[0];

      if (mantissa != 8388607) {
        bodyTemperatureValue = mantissa * pow(10, exponent) / 100.0;
      }
    }
    return Temperature(value: bodyTemperatureValue, unit: unit);
  }
}