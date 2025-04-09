import 'dart:typed_data';

import 'package:equatable/equatable.dart';
class Blob {
  final BlobInfo blobInfo;
  final List<BlobPacket> packets;
   DateTime? createdAt;
   DateTime? closedAt;

  Blob({required this.blobInfo, required this.packets,  this.createdAt,  this.closedAt});
  @override
  String toString() {
    // TODO: implement toString
    final toString = " packets ${packets[0].packetInfo} ";
    return toString;
  }
}

class BlobPacket extends Equatable {
   PacketInfo? packetInfo;
   List<int>? packetData;

   BlobPacket({
     this.packetInfo,
     this.packetData,
  });

  /// Dirección como rango hexadecimal (usando las props procesadas de PacketInfo) 
  String get addrRange => '${packetInfo?.address} - ${packetInfo?.dataAddress}';

  /// Datos crudos completos: encabezado + payload


  /// Clone con nuevos datos opcionales
  BlobPacket copyWith({
    PacketInfo? packetInfo,
    List<int>? packetData,
  }) {
    return BlobPacket(
      packetInfo: packetInfo ?? this.packetInfo,
      packetData: packetData ?? this.packetData,
    );
  }

  @override
  List<Object?> get props => [packetInfo, packetData];

  @override
  String toString() =>
      'BlobPacket(addrRange: $addrRange, timestamp: ${  DateTime.fromMillisecondsSinceEpoch( packetInfo!.timestamp )}, size: ${packetInfo!.packetSize}, dataLen: ${packetData!.length})';
}

class BlobInfo {
  int? address;
  int? blobType;
  int? blobNumPackets;
  int? blobSize;
  int? extraDataLen;
  List<int>? extraData;
  
   BlobInfo({
    this.address,
    this.blobType,
    this.blobNumPackets,
    this.blobSize,
    this.extraDataLen,
    this.extraData,
  });
  int get endAddress => address! + blobSize! - 1;

  static BlobInfo parseValue(List<int> value) {
    final blobInfo = BlobInfo();
    
    // Parseo de los campos
    blobInfo.address = _bytesToUInt(value.sublist(0, 3));
    blobInfo.blobType = value[3];
    blobInfo.blobNumPackets = _bytesToUInt(value.sublist(4, 6));
    blobInfo.blobSize = _bytesToUInt(value.sublist(6, 9));
    blobInfo.extraDataLen = value[9];
    
    if (blobInfo.extraDataLen! > 0) {
      blobInfo.extraData = value.sublist(10, value.length - 1);
    }
    
    return blobInfo;
  }

  Uint8List getRawData() {
    final rawData = BytesBuilder();
    
    // Construcción de los datos en little-endian
    rawData.addByte(blobType!);
    rawData.addByte(extraDataLen!);
    rawData.add(_uintToBytes(blobNumPackets!, 2));
    rawData.add(_uintToBytes(blobSize!, 4));
    
    final nextBlobAddress = address! + blobSize!;
    rawData.add(_uintToBytes(nextBlobAddress, 4));
    
    if (extraDataLen! > 0 && extraData != null) {
      rawData.add(extraData!);
    }
    
    return rawData.toBytes();
  }

  // Helper: Convertir bytes a entero unsigned little-endian
  static int _bytesToUInt(List<int> bytes) {
    int result = 0;
  
    for (int i = 0; i < bytes.length; i++) {
      assert(bytes[i] >= 0 && bytes[i] <= 255, 'Byte value out of range (0-255)');
      result |= (bytes[i] & 0xFF) << (8 * i); // Mask with 0xFF para asegurar unsigned
    }
    
    return result;
  }

  // Helper: Convertir entero a bytes unsigned little-endian
  static Uint8List _uintToBytes(int value, int length) {
    // Validaciones
    assert(value >= 0, 'Value must be non-negative (unsigned)');
    assert(length > 0, 'Length must be positive');
    
    // Máximo valor que puede representarse con [length] bytes
    final maxValue = (1 << (8 * length)) - 1;
    assert(value <= maxValue, 'Value too large for $length bytes');
    
    // Conversión a bytes little-endian
    final result = Uint8List(length);
    for (int i = 0; i < length; i++) {
      result[i] = (value >> (8 * i)) & 0xFF;
    }
    return result;
  }
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
    print('RAW packetInfo bytes: ${value.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

  if (value.length < 15) return null;

  final address = _toIntLE(value.sublist(0, 3));
  final dataAddress = _toIntLE(value.sublist(3, 6));
  final packetType = value[6];
  final blobType = value[7];
  final packetSize = _toIntLE(value.sublist(8, 11));
  final timestamp = _toIntLE(value.sublist(11, 15));

  int ms = 0;
  if (value.length >= 17) {
    ms = _toIntLE(value.sublist(15, 17));
    if (ms > 999) {
      ms = 0; 
      print('se ha corregido ms');
    }
  }



  final createdAt = DateTime.fromMillisecondsSinceEpoch(
    timestamp * 1000 ,
    isUtc: true,
  );


  int timestampClosed = 0;
  int msClosed = 0;
  DateTime closedAt = createdAt;

  if (value.length >= 21) {
    timestampClosed = _toIntLE(value.sublist(17, 21));
    if (value.length >= 23) {
      msClosed = _toIntLE(value.sublist(21, 23));
    }
    closedAt = DateTime.fromMillisecondsSinceEpoch(
      timestampClosed * 1000 +  msClosed,
      isUtc: true
    );
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
  static List<PacketInfo> fromMultipleRaw(List<int> data) {
    final result = <PacketInfo>[];
    int offset = 0;

    while (offset + 15 <= data.length) {
      // Intentamos parsear desde la posición actual
      final sub = data.sublist(offset);
      final packet = PacketInfo.fromRaw(sub);

      if (packet == null) break;

      result.add(packet);

      // Avanzamos el offset al siguiente bloque
      offset += packet.packetSize;

      // Prevención por si el tamaño no tiene sentido
      if (packet.packetSize <= 0 || offset > data.length) break;
    }

    return result;
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

/// Convierte una lista de bytes a un entero sin signo en formato little-endian
/// [bytes] - Lista de bytes (cada elemento debe ser 0-255)
/// Retorna el valor entero sin signo
  static int _toIntLE(List<int> bytes) {
    int result = 0;
  
    for (int i = 0; i < bytes.length; i++) {
      assert(bytes[i] >= 0 && bytes[i] <= 255, 'Byte value out of range (0-255)');
      result |= (bytes[i] & 0xFF) << (8 * i); // Mask with 0xFF para asegurar unsigned
    }
    
    return result;
  }

  /// Convierte un entero no negativo a lista de bytes en formato little-endian
  /// [value] - Valor entero a convertir (debe ser >= 0)
  /// [length] - Cantidad de bytes en el resultado
  /// Retorna List<int> con los bytes en little-endian
  static List<int> _toBytesLE(int value, int length) {
    // Validaciones
    assert(value >= 0, 'Value must be non-negative (unsigned)');
    assert(length > 0, 'Length must be positive');
    
    // Máximo valor que puede representarse con [length] bytes
    final maxValue = (1 << (8 * length)) - 1;
    assert(value <= maxValue, 'Value too large for $length bytes');
    
    // Conversión a bytes little-endian
    final result = Uint8List(length);
    for (int i = 0; i < length; i++) {
      result[i] = (value >> (8 * i)) & 0xFF;
    }
    return result;
  }

  @override
  String toString() => 'PacketInfo($packetSizeStr, ts: $createdAt)';
}
