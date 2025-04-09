enum GyroScale {
  scale250dps,
  scale500dps,
  scale1000dps,
  scale2000dps,
  scale125dps,
}

extension GyroScaleExtension on GyroScale {
  int get rawValue {
    switch (this) {
      case GyroScale.scale250dps: return 0;
      case GyroScale.scale500dps: return 2;
      case GyroScale.scale1000dps: return 4;
      case GyroScale.scale2000dps: return 6;
      case GyroScale.scale125dps: return 1;
    }
  }

  double getScaleFactor() {
    switch (this) {
      case GyroScale.scale125dps: return 125 / (1 << 15);
      case GyroScale.scale250dps: return 125 / (1 << 14);
      case GyroScale.scale500dps: return 125 / (1 << 13);
      case GyroScale.scale1000dps: return 125 / (1 << 12);
      case GyroScale.scale2000dps: return 125 / (1 << 11);
    }
  }

  String get label {
    switch (this) {
      case GyroScale.scale125dps: return '125 dps';
      case GyroScale.scale250dps: return '250 dps';
      case GyroScale.scale500dps: return '500 dps';
      case GyroScale.scale1000dps: return '1000 dps';
      case GyroScale.scale2000dps: return '2000 dps';
    }
  }
}

class GyroScaleHelper {
  static GyroScale fromRaw(int raw) {
    switch (raw) {
      case 0: return GyroScale.scale250dps;
      case 1: return GyroScale.scale125dps;
      case 2: return GyroScale.scale500dps;
      case 4: return GyroScale.scale1000dps;
      case 6: return GyroScale.scale2000dps;
      default: return GyroScale.scale250dps;
    }
  }
}
