import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
class Blob extends Equatable {
  final PacketInfo packetInfo;
  final List<int> packetData;

  const Blob({
    required this.packetInfo,
    required this.packetData,
  });

  /// Dirección como rango hexadecimal (usando las props procesadas de PacketInfo)
  String get addrRange => '${packetInfo.address} - ${packetInfo.dataAddress}';

  /// Datos crudos completos: encabezado + payload


  /// Duración total del paquete
  Duration get duration => packetInfo.duration;


  /// Clone con nuevos datos opcionales
  Blob copyWith({
    PacketInfo? packetInfo,
    List<int>? packetData,
  }) {
    return Blob(
      packetInfo: packetInfo ?? this.packetInfo,
      packetData: packetData ?? this.packetData,
    );
  }

  @override
  List<Object?> get props => [packetInfo, packetData];

  @override
  String toString() =>
      'Blob(addrRange: $addrRange, timestamp: ${  DateTime.fromMillisecondsSinceEpoch( packetInfo.timestamp * 10000 )}, size: ${packetInfo.packetSize}, dataLen: ${packetData.length})';
}


class PacketInfo extends Equatable {
  final int address;
  final int dataAddress;
  final int packetType;
  final int blobType;
  final int packetSize;

  final int timestamp;
  final int ms;
  final DateTime createdAt;

  final int timestampClosed;
  final int msClosed;
  final DateTime closedAt;

  const PacketInfo({
    required this.address,
    required this.dataAddress,
    required this.packetType,
    required this.blobType,
    required this.packetSize,
    required this.timestamp,
    required this.ms,
    required this.createdAt,
    required this.timestampClosed,
    required this.msClosed,
    required this.closedAt,
  });

  /// Direcciones como texto
  String get addressHex => '0x${address.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  String get dataAddressHex => '0x${dataAddress.toRadixString(16).padLeft(6, '0').toUpperCase()}';

  /// Tamaño legible
  String get packetSizeStr =>
      packetSize >= 1024 ? '${(packetSize / 1024).toStringAsFixed(2)} KB' : '$packetSize bytes';

  /// Rango
  int get endAddress => address + packetSize - 1;

  /// Diferencia entre data y start
  int get headerSize => dataAddress - address;

  /// Datos reales
  int get dataSize => packetSize - headerSize;

  /// Duración entre timestamps
  Duration get duration => closedAt.difference(createdAt);

  static PacketInfo? fromRaw(List<int> value) {
    if (value.length < 15) return null;

    final address = _toIntLE(value.sublist(0, 3));
    final dataAddress = _toIntLE(value.sublist(3, 6));
    final packetType = value[6];
    final blobType = value[7];
    final packetSize = _toIntLE(value.sublist(8, 11));
    final timestamp = _toIntLE(value.sublist(11, 15));

    int ms = value.length >= 17 ? _toIntLE(value.sublist(15, 17)) : 0;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000 + ms, isUtc: true);

    int timestampClosed = 0;
    int msClosed = 0;
    DateTime closedAt = createdAt;

    if (value.length >= 21) {
      timestampClosed = _toIntLE(value.sublist(17, 21));
      if (value.length >= 23) {
        msClosed = _toIntLE(value.sublist(21, 23));
      }
      closedAt = DateTime.fromMillisecondsSinceEpoch(timestampClosed * 1000 + msClosed, isUtc: true);
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
  }

  List<int> getRawData() {
    return [
      ..._toBytesLE(timestamp, 4),
      ..._toBytesLE(ms, 2),
      packetType,
      blobType,
      ..._toBytesLE(packetSize, 4),
      ..._toBytesLE(timestampClosed, 4),
      ..._toBytesLE(msClosed, 2),
    ];
  }

  PacketInfo copyWith({
    int? address,
    int? dataAddress,
    int? packetType,
    int? blobType,
    int? packetSize,
    int? timestamp,
    int? ms,
    DateTime? createdAt,
    int? timestampClosed,
    int? msClosed,
    DateTime? closedAt,
  }) {
    return PacketInfo(
      address: address ?? this.address,
      dataAddress: dataAddress ?? this.dataAddress,
      packetType: packetType ?? this.packetType,
      blobType: blobType ?? this.blobType,
      packetSize: packetSize ?? this.packetSize,
      timestamp: timestamp ?? this.timestamp,
      ms: ms ?? this.ms,
      createdAt: createdAt ?? this.createdAt,
      timestampClosed: timestampClosed ?? this.timestampClosed,
      msClosed: msClosed ?? this.msClosed,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  List<Object?> get props => [
        address,
        dataAddress,
        packetType,
        blobType,
        packetSize,
        timestamp,
        ms,
        createdAt,
        timestampClosed,
        msClosed,
        closedAt,
      ];

  static int _toIntLE(List<int> bytes) {
    int result = 0;
    for (int i = 0; i < bytes.length; i++) {
      result |= (bytes[i] << (8 * i));
    }
    return result;
  }

  static List<int> _toBytesLE(int value, int length) {
    final result = List<int>.filled(length, 0);
    for (int i = 0; i < length; i++) {
      result[i] = (value >> (8 * i)) & 0xFF;
    }
    return result;
  }

  @override
  String toString() => 'PacketInfo($addressHex → $dataAddressHex, $packetSizeStr, ts: $createdAt)';
}
