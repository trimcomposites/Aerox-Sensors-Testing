enum ImuSampleRate {
  sampleRate104Hz,
  sampleRate208Hz,
  sampleRate416Hz,
  sampleRate833Hz,
  sampleRate1_66kHz,
  sampleRate3_33kHz,
  sampleRate6_66kHz,
  sampleRate1kHz,
}

extension ImuSampleRateExtension on ImuSampleRate {
  int get rawValue {
    switch (this) {
      case ImuSampleRate.sampleRate104Hz: return 4;   // 0b0100
      case ImuSampleRate.sampleRate208Hz: return 5;   // 0b0101
      case ImuSampleRate.sampleRate416Hz: return 6;   // 0b0110
      case ImuSampleRate.sampleRate833Hz: return 7;   // 0b0111
      case ImuSampleRate.sampleRate1_66kHz: return 8; // 0b1000
      case ImuSampleRate.sampleRate3_33kHz: return 9; // 0b1001
      case ImuSampleRate.sampleRate6_66kHz: return 10;// 0b1010
      case ImuSampleRate.sampleRate1kHz: return 0;    // 0b0000
    }
  }

  int getSampleRateValue() {
    switch (this) {
      case ImuSampleRate.sampleRate104Hz: return 104;
      case ImuSampleRate.sampleRate208Hz: return 208;
      case ImuSampleRate.sampleRate416Hz: return 416;
      case ImuSampleRate.sampleRate833Hz: return 833;
      case ImuSampleRate.sampleRate1_66kHz: return 1660;
      case ImuSampleRate.sampleRate3_33kHz: return 3330;
      case ImuSampleRate.sampleRate6_66kHz: return 6660;
      case ImuSampleRate.sampleRate1kHz: return 1000;
    }
  }

  String get label {
    switch (this) {
      case ImuSampleRate.sampleRate104Hz: return '104 Hz';
      case ImuSampleRate.sampleRate208Hz: return '208 Hz';
      case ImuSampleRate.sampleRate416Hz: return '416 Hz';
      case ImuSampleRate.sampleRate833Hz: return '833 Hz';
      case ImuSampleRate.sampleRate1_66kHz: return '1.66 kHz';
      case ImuSampleRate.sampleRate3_33kHz: return '3.33 kHz';
      case ImuSampleRate.sampleRate6_66kHz: return '6.66 kHz';
      case ImuSampleRate.sampleRate1kHz: return '1 kHz (imu timer)';
    }
  }

  static ImuSampleRate fromRaw(int raw) {
    return ImuSampleRate.values.firstWhere(
      (e) => e.rawValue == raw,
      orElse: () => ImuSampleRate.sampleRate104Hz,
    );
  }
}
class ImuSampleRateHelper {
  static ImuSampleRate fromRaw(int raw) {
    return ImuSampleRate.values.firstWhere(
      (e) => e.rawValue == raw,
      orElse: () => ImuSampleRate.sampleRate104Hz,
    );
  }
}
