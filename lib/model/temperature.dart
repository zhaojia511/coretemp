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

  @override String toString() {
    // TODO: implement toString
      return "$value${unit.toString()}";
  }
}