import 'dart:typed_data';

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
      final gyroScale = GyroScaleHelper.fromRaw(extra[2]).getScaleFactor();
      nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
      scales.addAll([gyroScale, gyroScale, gyroScale]);
    }

    if (includeAcc) {
      final accScale = AccScaleHelper.fromRaw(extra[1]).getScaleFactor();
      nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
      scales.addAll([accScale, accScale, accScale]);
    }

    final result = <Map<String, dynamic>>[];
    int globalSampleIndex = 0;

    for (var packetIndex = 0; packetIndex < blob.packets.length; packetIndex++) {
      final packet = blob.packets[packetIndex];
      final data = packet.packetData!;
      final createdAt = packet.packetInfo!.createdAt;

      final bytesPerSample = nameVars.length * 2;
      final numSamples = data.length ~/ bytesPerSample;

      for (int i = 0; i < numSamples; i++) {
        final offset = i * bytesPerSample;
        final sampleBytes = data.sublist(offset, offset + bytesPerSample);
        final row = <String, dynamic>{};

        row['sample_num'] = globalSampleIndex;

        for (int j = 0; j < nameVars.length; j++) {
          final byteIndex = j * 2;
          final low = sampleBytes[byteIndex];
          final high = sampleBytes[byteIndex + 1];
          final raw = _toInt16LE(low, high);
          final scaled = raw * scales[j];
          row[nameVars[j]] = scaled;


        }

        row['delta_t'] = deltaTime;
        row['absolute_time'] = deltaTime * globalSampleIndex;
        row['timestamp'] = createdAt.add(Duration(microseconds: (deltaTime * 1e6 * i).round()));

        result.add(row);
        globalSampleIndex++;
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
      final gyroScale = GyroScaleHelper.fromRaw(extra[1]).getScaleFactor();
      nameVars.addAll(['gyro_x', 'gyro_y', 'gyro_z']);
      scales.addAll([gyroScale, gyroScale, gyroScale]);
    }

    if (includeAcc) {
      final accScale = AccScaleHelper.fromRaw(extra[0]).getScaleFactor();
      nameVars.addAll(['acc_x', 'acc_y', 'acc_z']);
      scales.addAll([accScale, accScale, accScale]);
    }

    final result = <Map<String, dynamic>>[];
    int globalSampleIndex = 0;

    for (var packetIndex = 0; packetIndex < blob.packets.length; packetIndex++) {
      final packet = blob.packets[packetIndex];
      final data = packet.packetData!;
      final createdAt = packet.packetInfo!.createdAt;

      final bytesPerSample = nameVars.length * 2;
      final numSamples = data.length ~/ bytesPerSample;

      for (int i = 0; i < numSamples; i++) {
        final offset = i * bytesPerSample;
        final sampleBytes = data.sublist(offset, offset + bytesPerSample);
        final row = <String, dynamic>{};

        row['sample_num'] = globalSampleIndex;
        //print('Sample $globalSampleIndex raw bytes: $sampleBytes');

        for (int j = 0; j < nameVars.length; j++) {
          final byteIndex = j * 2;
          final low = sampleBytes[byteIndex];
          final high = sampleBytes[byteIndex + 1];
          final raw = _toInt16LE(low, high);
          final scaled = raw * scales[j];
          row[nameVars[j]] = scaled;

          //print('  ${nameVars[j]} raw: $raw, scaled: $scaled');
        }

        row['delta_t'] = deltaTime;
        row['absolute_time'] = deltaTime * globalSampleIndex;
        row['timestamp'] = createdAt.add(Duration(microseconds: (deltaTime * 1e6 * i).round()));

        result.add(row);
        globalSampleIndex++;
      }
    }

    return result;
  }

  int _toInt16LE(int low, int high) {
    final bytes = Uint8List.fromList([low, high]);
    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt16(0, Endian.little);
  }
  
}
