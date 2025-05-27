class BatteryLevelMeasurement {
  final int value;
  final int mvolts;

  BatteryLevelMeasurement(this.value) : mvolts = value * 100;

  double get battPercent {
    if (mvolts > 4000) {
      return 100;
    } else if (mvolts > 3600) {
      return _interpolate(3600, 4000, 40, 90);
    } else if (mvolts > 3400) {
      return _interpolate(3400, 3600, 10, 40);
    } else {
      return _interpolate(3000, 3400, 0, 10);
    }
  }

  double _interpolate(int minBat, int maxBat, int minPercent, int maxPercent) {
    return minPercent +
        (maxPercent - minPercent) * ((mvolts - minBat) / (maxBat - minBat));
  }

  List<int> toBytes() {
    return [value];
  }

  static BatteryLevelMeasurement parse(List<int> value) {
    final val = value.isNotEmpty ? value[0] : 0;
    return BatteryLevelMeasurement(val);
  }
}
