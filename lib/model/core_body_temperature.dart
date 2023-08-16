import 'package:zzsports/model/temperature_unit.dart';

enum CBTQuality { //核心体温数据的可靠性
  invalid,
  poor,
  fair,
  good,
  excellent,
  unavailable; //可靠性无法获取

  static CBTQuality qualityFromIndex(int index) {
    if (index >= 0 && index < CBTQuality.values.length) {
      return CBTQuality.values[index];
    } else {
      return CBTQuality.unavailable;
    }
  }
}

enum HRMState { //心率测量状态
  unsupported, //不支持HRM
  supported, //支持但未收到数据
  receiving, //正在接收数据
  unavailable; //状态无法获取

  static HRMState hrmStateFromIndex(int index) {
  if (index >= 0 && index < HRMState.values.length) {
    return HRMState.values[index];
  } else {
    return HRMState.unavailable;
  }
  }
}

class CoreBodyTemperature {
  CoreBodyTemperature({
    required this.coreTemperature,
    required this.hrmState,
    required this.dataQuality,
    required this.skinTemperature,
    required this.unit,
  });

  final double coreTemperature;
  final double skinTemperature;
  final CBTQuality dataQuality;
  final HRMState hrmState;
  final TemperatureUnit unit;

  static CoreBodyTemperature instanceFromData(List<int> data) {
    double coreTemperature = 0;
    double skinTemperature = 0;
    CBTQuality quality = CBTQuality.unavailable;
    HRMState state = HRMState.unavailable;
    TemperatureUnit unit = TemperatureUnit.C;

    if (data.length == 8) {
      int qualityNumber = data[7] & 7; //第8个字节的0-3bit表示核心温度的可靠性
      quality = CBTQuality.qualityFromIndex(qualityNumber);
      int stateNumber = data[7] & 24; //第8个字节的4-5bit表示心率测量状态
      state = HRMState.hrmStateFromIndex(stateNumber);

      unit = TemperatureUnit.unitFromIndex((data[0] & 8)); //第一个字节的第3bit表示单位，0为摄氏度，1为华氏度

      int coreNumber = data[2]*256+data[1];
      if (coreNumber == 32767) { //若核心温度的两个字节是FF7F，即32767，表示温度无效
        quality = CBTQuality.invalid;
      } else {
        coreTemperature = coreNumber/100.0;
      }

      int skinNumber = data[4]*256+data[3];
      skinTemperature = skinNumber/100.0;
    }
    return CoreBodyTemperature(coreTemperature: coreTemperature,
        hrmState: state,
        dataQuality: quality,
        skinTemperature: skinTemperature,
        unit: unit);
  }
}