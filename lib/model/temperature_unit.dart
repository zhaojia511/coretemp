enum TemperatureUnit {
  C,
  F;

  static TemperatureUnit unitFromIndex(int index) {
    return (index == 0) ? TemperatureUnit.C : TemperatureUnit.F;
  }
}