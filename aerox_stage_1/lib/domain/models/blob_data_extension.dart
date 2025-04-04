
import 'package:aerox_stage_1/domain/models/blob.dart';

extension BlobDataExtension on Blob {
  List<Map<String, dynamic>> parseHs1kHzBlob({
    int sampleRate = 1000,
  }) {
    const RTSOS_GYRO_DATA_MASK = 0x02;
    const RTSOS_ACCEL_DATA_MASK = 0x04;

    final deltaTime = Duration(microseconds: (1000000 / sampleRate).round());
    final extra = extraData;

    double? accScale;
    double? gyroScale;
    int? dataMask;

    bool includeAcc = false;
    bool includeGyro = false;

    if (extra.length >= 3) {
      accScale = _accScaleFromByte(extra[0]);
      gyroScale = _gyroScaleFromByte(extra[1]);
      dataMask = extra[2];

      includeAcc = (dataMask & RTSOS_ACCEL_DATA_MASK) > 0;
      includeGyro = (dataMask & RTSOS_GYRO_DATA_MASK) > 0;
    }

    final nameVars = <String>[];
    final scales = <double>[];

    if (includeGyro) {
      nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
      scales.addAll([gyroScale!, gyroScale, gyroScale]);
    }
    if (includeAcc) {
      nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
      scales.addAll([accScale!, accScale, accScale]);
    }

    final parsedData = <Map<String, dynamic>>[];

    for (int packetNum = 0; packetNum < packets.length; packetNum++) {
      final packet = packets[packetNum];

      final values = _parsePacketData(
        data: packet.packetData,
        scales: scales,
        varNames: nameVars,
        startTime: packet.packetInfo.createdAt,
        delta: deltaTime,
      );

      for (var sample in values) {
        sample['packet_num'] = packetNum;
        parsedData.add(sample);
      }
    }

    return parsedData;
  }

  double _accScaleFromByte(int value) {
    switch (value) {
      case 0: return 2.0;
      case 1: return 4.0;
      case 2: return 8.0;
      case 3: return 16.0;
      default: return 1.0;
    }
  }

  double _gyroScaleFromByte(int value) {
    switch (value) {
      case 0: return 250.0;
      case 1: return 500.0;
      case 2: return 1000.0;
      case 3: return 2000.0;
      default: return 1.0;
    }
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
        if (index + 1 >= data.length) break; // seguridad extra
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

  Blob copyWith({
    int? address,
    int? blobType,
    int? blobNumPackets,
    int? blobSize,
    int? extraDataLen,
    List<int>? extraData,
    List<BlobPacket>? packets,
    DateTime? createdAt,
    DateTime? closedAt,
  }) {
    return Blob(
      address: address ?? this.address,
      blobType: blobType ?? this.blobType,
      blobNumPackets: blobNumPackets ?? this.blobNumPackets,
      blobSize: blobSize ?? this.blobSize,
      extraDataLen: extraDataLen ?? this.extraDataLen,
      extraData: extraData ?? this.extraData,
      packets: packets ?? this.packets,
      createdAt: createdAt ?? this.createdAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

}
extension PacketInfoParser on List<int> {
  PacketInfo? toPacketInfo() {
    try {
      final address = this[0] | (this[1] << 8) | (this[2] << 16);
      final dataAddress = this[3] | (this[4] << 8) | (this[5] << 16);
      final packetType = this[6];
      final blobType = this[7];
      final packetSize = this[8] | (this[9] << 8) | (this[10] << 16);
      final timestamp = this[11] | (this[12] << 8) | (this[13] << 16) | (this[14] << 24);
      final ms = (this.length >= 17) ? this[15] | (this[16] << 8) : 0;
      final createdAt = DateTime.fromMillisecondsSinceEpoch((timestamp * 1000 + ms), isUtc: true);

      int timestampClosed = 0;
      int msClosed = 0;
      DateTime closedAt = createdAt;

      if (this.length >= 21) {
        timestampClosed = this[17] | (this[18] << 8) | (this[19] << 16) | (this[20] << 24);
      }
      if (this.length >= 23) {
        msClosed = this[21] | (this[22] << 8);
      }
      if (timestampClosed != 0) {
        closedAt = DateTime.fromMillisecondsSinceEpoch((timestampClosed * 1000 + msClosed), isUtc: true);
      }

      return PacketInfo(
        address: address,
        dataAddress: dataAddress,
        packetType: packetType,
        blobType: blobType,
        packetSize: packetSize,
        timestamp: timestamp,
        ms: ms,
        createdAt: createdAt,
        timestampClosed: timestampClosed,
        msClosed: msClosed,
        closedAt: closedAt,
      );
    } catch (e) {
      print("Error parsing PacketInfo: $e");
      return null;
    }
  }
}
