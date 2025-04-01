import 'package:aerox_stage_1/common/utils/bloc/UIState.dart';
import 'package:aerox_stage_1/common/utils/error/err/bluetooth_err.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/models/racket_sensor_entity.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/disconnect_from_racket_sensor_usecase.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/get_selected_bluetooth_racket_usecase.dart';
import 'package:aerox_stage_1/features/feature_bluetooth/blocs/selected_entity_page/selected_entity_page_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mock_types.dart';

class MockDisconnectFromRacketSensorUsecase extends Mock implements DisconnectFromRacketSensorUsecase {}
class MockGetSelectedBluetoothRacketUsecase extends Mock implements GetSelectedBluetoothRacketUsecase {}

void main() {
  late SelectedEntityPageBloc selectedEntityPageBloc;
  late DisconnectFromRacketSensorUsecase disconnectUsecase;
  late GetSelectedBluetoothRacketUsecase getSelectedRacketUsecase;

  setUp(() {
    disconnectUsecase = MockDisconnectFromRacketSensorUsecase();
    getSelectedRacketUsecase = MockGetSelectedBluetoothRacketUsecase();

    selectedEntityPageBloc = SelectedEntityPageBloc(
      disconnectFromRacketSensorUsecase: disconnectUsecase,
      getSelectedBluetoothRacketUsecase: getSelectedRacketUsecase,
      
    );
  });

  tearDown(() {
    selectedEntityPageBloc.close();
  });

  final device = MockBluetoothDevice();
  final List<RacketSensor> sensorsList = [
    RacketSensor(id: "1", name: "Sensor1", device: device, connectionState: BluetoothConnectionState.connected),
  ];

  final RacketSensorEntity sensorEntity = RacketSensorEntity(id: "1", name: "Sensor1", sensors: sensorsList);

  group('OnGetSelectedRacketSelectedEntityPage', () {
  blocTest<SelectedEntityPageBloc, SelectedEntityPageState>(
    'emits [loading] and gets selected racket successfully',
    build: () {
      when(() => getSelectedRacketUsecase.call()).thenAnswer((_) async => Right(sensorEntity));
      when(() => device.connectionState).thenAnswer((_) => Stream.value(BluetoothConnectionState.connected));

      return selectedEntityPageBloc;
    },
    act: (bloc) => bloc.add(OnGetSelectedRacketSelectedEntityPage()),
    expect: () => [
      SelectedEntityPageState(uiState: UIState.loading(), selectedRacketEntity: null),
      SelectedEntityPageState(uiState: UIState.idle(), selectedRacketEntity: sensorEntity),
    ],
  );


    blocTest<SelectedEntityPageBloc, SelectedEntityPageState>(
      'emits [error] when getting selected racket fails',
      build: () {
        when(() => getSelectedRacketUsecase.call()).thenAnswer((_) async => Left(BluetoothErr(errMsg: "Error fetching racket", statusCode: 1)));
        return selectedEntityPageBloc;
      },
      act: (bloc) => bloc.add(OnGetSelectedRacketSelectedEntityPage()),
      expect: () => [
        SelectedEntityPageState(uiState: UIState.loading(), selectedRacketEntity: null),
        SelectedEntityPageState(uiState: UIState.error("Error fetching racket"), selectedRacketEntity: null),
      ],
    );
  });

  group('OnDisconnectSelectedRacketSelectedEntityPage', () {
    blocTest<SelectedEntityPageBloc, SelectedEntityPageState>(
      'emits [loading] and disconnects successfully',
      build: () {
        when(() => disconnectUsecase.call(sensorEntity)).thenAnswer((_) async => Right(null));
        return selectedEntityPageBloc;
      },
      seed: () => SelectedEntityPageState(uiState: UIState.idle(), selectedRacketEntity: sensorEntity),
      act: (bloc) => bloc.add(OnDisconnectSelectedRacketSelectedEntityPage()),
      expect: () => [
        SelectedEntityPageState(uiState: UIState.loading(), selectedRacketEntity: sensorEntity),
        SelectedEntityPageState(uiState: UIState.idle(), selectedRacketEntity: null),
      ],
    );

    blocTest<SelectedEntityPageBloc, SelectedEntityPageState>(
      'emits [error] when disconnection fails',
      build: () {
        when(() => disconnectUsecase.call(sensorEntity)).thenAnswer((_) async => Left(BluetoothErr(errMsg: "Disconnection failed", statusCode: 1)));
        return selectedEntityPageBloc;
      },
      seed: () => SelectedEntityPageState(uiState: UIState.idle(), selectedRacketEntity: sensorEntity),
      act: (bloc) => bloc.add(OnDisconnectSelectedRacketSelectedEntityPage()),
      expect: () => [
        SelectedEntityPageState(uiState: UIState.loading(), selectedRacketEntity: sensorEntity),
        SelectedEntityPageState(uiState: UIState.error("Disconnection failed"), selectedRacketEntity: null),
      ],
    );
  });

  group('OnShowConnectionError', () {
    blocTest<SelectedEntityPageBloc, SelectedEntityPageState>(
      'emits [error] with a connection issue message',
      build: () => selectedEntityPageBloc,
      act: (bloc) => bloc.add(OnShowConnectionError(errorMsg: 'Connection lost')),
      expect: () => [
        SelectedEntityPageState(uiState: UIState.error('Connection lost')),
      ],
    );
  });
}
