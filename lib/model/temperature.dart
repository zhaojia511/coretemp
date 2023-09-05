enum TemperatureUnit {
  C,
  F;

  static TemperatureUnit unitFromIndex(int index) {
    return (index == 0) ? TemperatureUnit.C : TemperatureUnit.F;
  }

  @override String toString() {
    return (this == F) ? "°F" : "℃";
  }
}

class Temperature {
  Temperature({
    required this.unit,
    required this.value,
  });

  final TemperatureUnit unit;
  final double value;
  final int timeStamp = DateTime.now().microsecondsSinceEpoch;

  @override String toString() {
    // TODO: implement toString
      return (value > 0) ? "$value${unit.toString()}" : "--${unit.toString()}";
  }
}