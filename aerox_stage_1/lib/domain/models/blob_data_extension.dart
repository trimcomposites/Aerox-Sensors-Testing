import 'dart:typed_data';

import 'package:aerox_stage_1/domain/models/blob.dart';

extension BlobDataExtension on Blob {
  List<Map<String, dynamic>> parseHs1kHzPacket({
    int sampleRate = 1000,
    required double accScale,
    required double gyroScale,
    required int dataMask,
  }) {
    const RTSOS_GYRO_DATA_MASK = 0x02;
    const RTSOS_ACCEL_DATA_MASK = 0x04;

    final deltaTime = Duration(microseconds: (1000000 / sampleRate).round());

    bool includeAcc = (dataMask & RTSOS_ACCEL_DATA_MASK) > 0;
    bool includeGyro = (dataMask & RTSOS_GYRO_DATA_MASK) > 0;

    final nameVars = <String>[];
    final scales = <double>[];

    if (includeGyro) {
      nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
      scales.addAll([gyroScale, gyroScale, gyroScale]);
    }
    if (includeAcc) {
      nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
      scales.addAll([accScale, accScale, accScale]);
    }

    final parsedData = <Map<String, dynamic>>[];

    /*final values = _parsePacketData(
      data: packetData,
      scales: scales,
      varNames: nameVars,
      startTime: packetInfo.createdAt,
      delta: deltaTime,
    );*/

    /*for (var sample in values) {
      sample['packet_addr'] = packetInfo.address.toRadixString(16);
      parsedData.add(sample);
    }*/

    return parsedData;
  }

  List<Map<String, dynamic>> _parsePacketData({
    required List<int> data,
    required List<double> scales,
    required List<String> varNames,
    required DateTime startTime,
    required Duration delta,
  }) {
    final results = <Map<String, dynamic>>[];
    final int sampleSize = varNames.length;
    final int totalSamples = (sampleSize > 0) ? data.length ~/ (2 * sampleSize) : 0;

    for (int i = 0; i < totalSamples; i++) {
      final sample = <String, dynamic>{};
      final timestamp = startTime.add(delta * i);
      sample['timestamp'] = timestamp.toIso8601String();

      for (int j = 0; j < sampleSize; j++) {
        final index = (i * sampleSize + j) * 2;
        if (index + 1 >= data.length) break;
        final raw = _toInt16(data[index], data[index + 1]);
        sample[varNames[j]] = raw * scales[j];
      }

      results.add(sample);
    }

    return results;
  }

  int _toInt16(int low, int high) {
    final value = (high << 8) | low;
    return value >= 0x8000 ? value - 0x10000 : value;
  }
}
extension PacketInfoParser on List<int> {
  PacketInfo? toPacketInfo() {
    return PacketInfo.fromRaw(this);
  }
}

extension BlobInfoParser on List<int> {
  BlobInfo toBlobInfo() {
    // Saltamos opcode (index 0) y status (index 1)
    final blobRaw = this.sublist(2);
    return BlobInfo.parseValue(blobRaw);
  }
}