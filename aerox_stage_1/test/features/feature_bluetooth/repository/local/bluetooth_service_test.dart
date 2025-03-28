import 'dart:async';

import 'package:aerox_stage_1/common/utils/error/err/err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_extension.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_permission_handler.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/repository/local/bluetooth_service.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

void main() {
  late BluetoothCustomService bluetoothService;
  late MockBluetoothPermissionHandler permissionHandler;
  late MockBluetoothDevice device;
  late RacketSensor sensor;

  setUpAll(() {
    registerFallbackValue(BluetoothConnectionState.connected);
  });
  final state = BluetoothConnectionState.connected;
  setUp(() {
    permissionHandler = MockBluetoothPermissionHandler();
    device = MockBluetoothDevice();

    sensor = RacketSensor(
      id: '1',
      name: 'SmartInsole',
      device: device,
      connectionState: BluetoothConnectionState.connected,
    );

    bluetoothService = BluetoothCustomService(permissionHandler: permissionHandler);
  });

  group('connectToDevice', () {
    test('returns Right when connection is successful', () async {
      when(() => device.connect()).thenAnswer((_) async {});
      final result = await bluetoothService.connectToDevice(sensor);
      expect(result, isA<Right>());
    });

    test('returns Left when connection throws', () async {
      when(() => device.connect()).thenThrow(Exception('fail'));
      final result = await bluetoothService.connectToDevice(sensor);
      expect(result, isA<Left>());
    });
  });

  group('disconnectFromDevice', () {
    test('returns Right when disconnect is successful', () async {
      when(() => device.isConnected).thenReturn(true);
      when(() => device.disconnect()).thenAnswer((_) async {});
      final result = await bluetoothService.disconnectFromDevice(sensor);
      expect(result, isA<Right>());
    });

    test('returns Right when already disconnected', () async {
      when(() => device.isConnected).thenReturn(false);
      final result = await bluetoothService.disconnectFromDevice(sensor);
      expect(result, isA<Right>());
    });

    test('returns Left when disconnect throws', () async {
      when(() => device.isConnected).thenReturn(true);
      when(() => device.disconnect()).thenThrow(Exception('error'));
      final result = await bluetoothService.disconnectFromDevice(sensor);
      expect(result, isA<Left>());
    });
  });

  group('getConnectedSensors', () {
    test('returns Right with connected sensors', () async {
      final mockDevice = MockBluetoothDevice();

      when(() => mockDevice.connectionState)
          .thenAnswer((_) => Stream.value(BluetoothConnectionState.connected));
      when(() => mockDevice.remoteId).thenReturn(const DeviceIdentifier('1'));
      when(() => mockDevice.platformName).thenReturn('SmartInsole');
      when(() => mockDevice.toRacketSensor(state: state))
          .thenAnswer((_) => sensor);


      final result = await bluetoothService.getConnectedSensors();
      expect(result, isA<Right<Err, List<RacketSensor>>>());
    });
  });
  group('stopScan y reScan', () {
    test('returns Right when not scanning', () async {
      final result = await bluetoothService.stopScan();
      expect(result.isRight(), true);
    });

    test('reScan returns Right even if not scanning', () async {
      final result = await bluetoothService.reScan();
      expect(result.isRight(), true);
    });
  });
}
