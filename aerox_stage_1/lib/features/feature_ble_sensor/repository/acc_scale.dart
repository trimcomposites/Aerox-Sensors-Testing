enum AccScale {
  scale2g,
  scale16g,
  scale4g,
  scale8g,
}

extension AccScaleExtension on AccScale {
  int get rawValue {
    switch (this) {
      case AccScale.scale2g: return 0;
      case AccScale.scale16g: return 1;
      case AccScale.scale4g: return 2;
      case AccScale.scale8g: return 3;
    }
  }

  double getScaleFactor() {
    switch (this) {
      case AccScale.scale2g: return 1 / (1 << 14); // 2^14
      case AccScale.scale4g: return 1 / (1 << 13);
      case AccScale.scale8g: return 1 / (1 << 12);
      case AccScale.scale16g: return 1 / (1 << 11);
    }
  }

  String get label {
    switch (this) {
      case AccScale.scale2g: return '2G';
      case AccScale.scale4g: return '4G';
      case AccScale.scale8g: return '8G';
      case AccScale.scale16g: return '16G';
    }
  }
}

class AccScaleHelper {
  static AccScale fromRaw(int raw) {
    switch (raw) {
      case 0: return AccScale.scale2g;
      case 1: return AccScale.scale16g;
      case 2: return AccScale.scale4g;
      case 3: return AccScale.scale8g;
      default: return AccScale.scale2g;
    }
  }
}
