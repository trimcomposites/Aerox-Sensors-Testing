import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/acc_scale.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/gyro_scale.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/imu_sample_rate.dart';
import 'package:aerox_stage_1/features/feature_ble_sensor/repository/storage_service_constants.dart';

class BlobDataParser {
  List<Map<String, dynamic>> parseHsRtsosBlob(Blob blob) {
  final extra = blob.blobInfo.extraData!;
final sampleRate = ImuSampleRateExtension.fromRaw(extra[0]).getSampleRateValue();
  final deltaTime = 1 / sampleRate;

  final nameVars = <String>[];
  final scales = <double>[];

  final requiredData = extra[3];
  final includeAcc = (requiredData & StorageServiceConstants.RTSOS_ACCEL_DATA_MASK) > 0;
  final includeGyro = (requiredData & StorageServiceConstants.RTSOS_GYRO_DATA_MASK) > 0;

  if (includeGyro) {
    nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
    final gyroScale = GyroScaleHelper.fromRaw(extra[2]).getScaleFactor();
    scales.addAll([gyroScale, gyroScale, gyroScale]);
  }

  if (includeAcc) {
    nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
    final accScale = AccScaleHelper.fromRaw(extra[1]).getScaleFactor();
    scales.addAll([accScale, accScale, accScale]);
  }

  final result = <Map<String, dynamic>>[];
  for (var i = 0; i < blob.packets.length; i++) {
    final packet = blob.packets[i];
    final parsed = parseSignedInt16Values(
      data: packet.packetData!,
      scales: scales,
      nameVars: nameVars,
      deltaTime: deltaTime,
      createdAt: packet.packetInfo!.createdAt,
    );
    for (var row in parsed) {
      row['packet_num'] = i;
      result.add(row);
    }
  }

  return result;
}
List<Map<String, dynamic>> parseHs1kzRtsosBlob(Blob blob) {
  final sampleRate = ImuSampleRate.sampleRate1kHz.getSampleRateValue();
  final deltaTime = 1 / sampleRate;

  final extra = blob.blobInfo.extraData!;
  final nameVars = <String>[];
  final scales = <double>[];

  final requiredData = extra[2];
  final includeAcc = (requiredData & StorageServiceConstants.RTSOS_ACCEL_DATA_MASK) > 0;
  final includeGyro = (requiredData & StorageServiceConstants.RTSOS_GYRO_DATA_MASK) > 0;

  if (includeGyro) {
    nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
    final gyroScale = GyroScaleHelper.fromRaw(extra[1]).getScaleFactor();
    scales.addAll([gyroScale, gyroScale, gyroScale]);
  }

  if (includeAcc) {
    nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
    final accScale = AccScaleHelper.fromRaw(extra[0]).getScaleFactor();
    scales.addAll([accScale, accScale, accScale]);
  }

  final result = <Map<String, dynamic>>[];
  for (var i = 0; i < blob.packets.length; i++) {
    final packet = blob.packets[i];
    final parsed = parseSignedInt16Values(
      data: packet.packetData!,
      scales: scales,
      nameVars: nameVars,
      deltaTime: deltaTime,
      createdAt: packet.packetInfo!.createdAt,
    );
    for (var row in parsed) {
      row['packet_num'] = i;
      result.add(row);
    }
  }

  return result;
}
List<Map<String, dynamic>> parseSignedInt16Values({
  required List<int> data,
  required List<double> scales,
  required List<String> nameVars,
  required double deltaTime,
  required DateTime createdAt,
}) {
  final result = <Map<String, dynamic>>[];

  final bytesPerSample = nameVars.length * 2; // 2 bytes por variable
  final numSamples = data.length ~/ bytesPerSample;

  for (int i = 0; i < numSamples; i++) {
    final offset = i * bytesPerSample;
    final sample = <String, dynamic>{};

    for (int j = 0; j < nameVars.length; j++) {
      final index = offset + j * 2;
      final raw = _toInt16LE(data[index], data[index + 1]);
      final scaled = raw * scales[j];
      sample[nameVars[j]] = scaled;
    }

    sample['timestamp'] = createdAt.add(Duration(
      microseconds: (deltaTime * 1e6 * i).round(),
    ));

    result.add(sample);
  }

  return result;
}

/// Interpreta dos bytes little-endian como int16 (signed)
int _toInt16LE(int low, int high) {
  final value = (high << 8) | low;
  return value >= 0x8000 ? value - 0x10000 : value;
}


}