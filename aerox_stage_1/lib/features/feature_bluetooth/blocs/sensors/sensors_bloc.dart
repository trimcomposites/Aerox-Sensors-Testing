import 'package:aerox_stage_1/domain/models/racket_sensor.dart';
import 'package:aerox_stage_1/domain/use_cases/bluetooth/scan_bluetooth_sensors_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sensors_event.dart';
part 'sensors_state.dart';

class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {

  final ScanBluetoothSensorsUsecase scanBluetoothSensorsUsecase;

  SensorsBloc({ 
    required this.scanBluetoothSensorsUsecase 
    }) : super(SensorsState()) {
    on<OnScanBluetoothSensors>( (event, emit) async {
      // ignore: avoid_single_cascade_in_expression_statements
      await scanBluetoothSensorsUsecase.call()..fold(
        ( l) => emit( state.copyWith(  ) ),  
        (r) => emit( state.copyWith( sensors: r ) )
        );
    });
  }
}
