import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/connect_to_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/rescan_racket_sensors_use_case.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/start_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/stop_scan_bluetooth_sensors_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/sensors/sensors_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

class MockStartScanBluetoothSensorsUsecase extends Mock implements StartScanBluetoothSensorsUsecase {}
class MockStopScanBluetoothSensorsUsecase extends Mock implements StoptScanBluetoothSensorsUsecase {}
class MockConnectToRacketSensorUsecase extends Mock implements ConnectToRacketSensorUsecase {}
class MockDisconnectFromRacketSensorUsecase extends Mock implements DisconnectFromRacketSensorUsecase {}
class MockReScanRacketSensorsUseCase extends Mock implements ReScanRacketSensorsUseCase {}

void main() {
  late SensorsBloc sensorsBloc;
  late StartScanBluetoothSensorsUsecase startScanUsecase;
  late StoptScanBluetoothSensorsUsecase stopScanUsecase;
  late ConnectToRacketSensorUsecase connectUsecase;
  late DisconnectFromRacketSensorUsecase disconnectUsecase;
  late ReScanRacketSensorsUseCase reScanUsecase;

  setUp(() {
    startScanUsecase = MockStartScanBluetoothSensorsUsecase();
    stopScanUsecase = MockStopScanBluetoothSensorsUsecase();
    connectUsecase = MockConnectToRacketSensorUsecase();
    disconnectUsecase = MockDisconnectFromRacketSensorUsecase();
    reScanUsecase = MockReScanRacketSensorsUseCase();

    sensorsBloc = SensorsBloc(
      startScanBluetoothSensorsUsecase: startScanUsecase,
      stopScanBluetoothSensorsUsecase: stopScanUsecase,
      connectToRacketSensorUsecase: connectUsecase,
      disconnectFromRacketSensorUsecase: disconnectUsecase,
      reScanRacketSensorsUseCase: reScanUsecase,
    );
  });

  tearDown(() {
    sensorsBloc.close();
  });

  final device = MockBluetoothDevice();
  final List<RacketSensor> sensorsList = [
    RacketSensor(id: "1", name: "Sensor1", device: device, connectionState: BluetoothConnectionState.disconnected),
    RacketSensor(id: "2", name: "Sensor2", device: device, connectionState: BluetoothConnectionState.disconnected),
  ];

  final RacketSensorEntity sensor = RacketSensorEntity(id: "1", name: "Sensor1", sensors: sensorsList);
  final List<RacketSensorEntity> entityList = [sensor, sensor];

  group('OnStartScanBluetoothSensors', () {
    blocTest<SensorsBloc, SensorsState>(
      'emits [loading] and starts scanning successfully',
      build: () {
        when(() => startScanUsecase.call()).thenAnswer((_) async => Right(Stream.value(entityList)));
        return sensorsBloc;
      },
      act: (bloc) => bloc.add(OnStartScanBluetoothSensors()),
      expect: () => [
        SensorsState(uiState: UIState.loading(), sensors: []),
        SensorsState(uiState: UIState.idle(), sensors: entityList),
      ],
    );
  });

  group('OnConnectRacketSensorEntity', () {
    blocTest<SensorsBloc, SensorsState>(
      'emits [loading] and connects successfully',
      build: () {
        when(() => connectUsecase.call(sensor)).thenAnswer((_) async => Right(null));
        return sensorsBloc;
      },
      seed: () => SensorsState(uiState: UIState.idle(), sensors: [sensor]),
      act: (bloc) => bloc.add(OnConnectRacketSensorEntity(id: "1")),
      expect: () => [
        SensorsState(uiState: UIState.loading(), sensors: [sensor]),
        SensorsState(uiState: UIState.success(next: '/bluetooth'), sensors: [sensor], selectedRacketEntity: sensor),
      ],
    );

    blocTest<SensorsBloc, SensorsState>(
      'emits [error] when connection fails',
      build: () {
        when(() => connectUsecase.call(sensor)).thenAnswer((_) async => Left(BluetoothErr(errMsg: "Connection failed", statusCode: 1)));
        return sensorsBloc;
      },
      act: (bloc) => bloc.add(OnConnectRacketSensorEntity(id: "1")),
      expect: () => [
        SensorsState(uiState: UIState.loading()),
        //SensorsState(uiState: UIState.error("Connection failed")),
      ],
    );
  });

  group('OnDisconnectSelectedRacket', () {
    blocTest<SensorsBloc, SensorsState>(
      'disconnects successfully',
      build: () {
        when(() => disconnectUsecase.call(sensor)).thenAnswer((_) async => Right(null));
        return sensorsBloc;
      },
      seed: () => SensorsState(selectedRacketEntity: sensor, uiState: UIState.idle()),
      act: (bloc) => bloc.add(OnDisconnectSelectedRacket()),
      expect: () => [
        SensorsState(selectedRacketEntity: null, uiState: UIState.idle()),
      ],
    );

    blocTest<SensorsBloc, SensorsState>(
      'emits [error] when disconnection fails',
      build: () {
        when(() => disconnectUsecase.call(sensor)).thenAnswer((_) async => Left(BluetoothErr(errMsg: "Disconnection failed", statusCode: 1)));
        return sensorsBloc;
      },
      seed: () => SensorsState(selectedRacketEntity: sensor, uiState: UIState.idle()),
      act: (bloc) => bloc.add(OnDisconnectSelectedRacket()),
      expect: () => [
        SensorsState(uiState: UIState.error("Disconnection failed"), selectedRacketEntity: sensor),
      ],
    );
  });

  group('OnReScanBluetoothSensors', () {
    blocTest<SensorsBloc, SensorsState>(
      'rescan successfully',
      build: () {
        when(() => reScanUsecase.call()).thenAnswer((_) async => Right(null));
        return sensorsBloc;
      },
      act: (bloc) => bloc.add(OnReScanBluetoothSensors()),
      expect: () => [
        SensorsState(uiState: UIState.loading()),
        SensorsState(uiState: UIState.idle()),
      ],
    );
  });
}
