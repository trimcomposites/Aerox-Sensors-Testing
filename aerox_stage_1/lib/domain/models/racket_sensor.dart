import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
enum BlobCheckStatus {
  ok,        // Num blobs confirmado
  mismatch,  //  Num blobs desincronizado
  failed,    // Fallo total 
}

class RacketSensor extends Equatable {
  final BluetoothDevice device;
  final String name;
  final String alias;
  final String id;
  final BluetoothConnectionState connectionState;
  final List<BluetoothService> services;
  final Map<String, BluetoothCharacteristic> characteristics;
  final Map<int, BlobCheckStatus> numBlobs;
  final int numRetries;


  const RacketSensor({
    required this.device,
    required this.name,
    required this.alias,
    required this.id,
    required this.connectionState,
    this.services = const [],
    this.characteristics = const {},
    this.numBlobs = const { 0 : BlobCheckStatus.ok },
    this.numRetries=0
  });

  RacketSensor copyWith({
    BluetoothDevice? device,
    String? name,
    String? alias,
    String? id,
    BluetoothConnectionState? connectionState,
    List<BluetoothService>? services,
    Map<String, BluetoothCharacteristic>? characteristics,
    Map<int, BlobCheckStatus>? numBlobs,
    int? numRetries
  }) {
    return RacketSensor(
      device: device ?? this.device,
      name: name ?? this.name,
      alias: alias ?? this.alias,
      id: id ?? this.id,
      connectionState: connectionState ?? this.connectionState,
      services: services ?? this.services,
      characteristics: characteristics ?? this.characteristics,
      numBlobs: numBlobs ?? this.numBlobs,
      numRetries: numRetries ?? this.numRetries
    );
  }

  @override
  List<Object?> get props => [
    device,
    name,
    alias,
    id,
    connectionState,
    services,
    characteristics,
    numBlobs,
    numRetries
  ];
}
