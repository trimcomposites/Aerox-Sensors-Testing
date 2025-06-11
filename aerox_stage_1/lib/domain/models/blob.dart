import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

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
  final PacketInfo? packetInfo;
  List<int>? packetData;

  BlobPacket({this.packetInfo, this.packetData});

  String get addrRange => '${packetInfo?.address} - ${packetInfo?.dataAddress}';

  BlobPacket copyWith({PacketInfo? packetInfo, List<int>? packetData}) => BlobPacket(
    packetInfo: packetInfo ?? this.packetInfo,
    packetData: packetData ?? this.packetData,
  );

  @override
  List<Object?> get props => [packetInfo, packetData];

  @override
  String toString() => 'BlobPacket(addrRange: $addrRange, ts: ${packetInfo != null ? formatPgStyle(packetInfo!.createdAt) : "null"})';
}
class BlobInfo {
  int? address, blobType, blobNumPackets, blobSize, extraDataLen;
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
    rawData.addByte(blobType!);
    rawData.addByte(extraDataLen!);
    rawData.add(_uintToBytes(blobNumPackets!, 2));
    rawData.add(_uintToBytes(blobSize!, 4));
    rawData.add(_uintToBytes(address! + blobSize!, 4));
    if (extraDataLen! > 0 && extraData != null) rawData.add(extraData!);
    return rawData.toBytes();
  }

  static int _bytesToUInt(List<int> bytes) =>
      bytes.asMap().entries.fold(0, (sum, e) => sum | (e.value << (8 * e.key)));



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
}class PacketInfo extends Equatable {
  final int address, dataAddress, packetType, blobType, packetSize;
  final int timestamp, ms, timestampClosed, msClosed;
  final DateTime createdAt, closedAt;

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

  static PacketInfo? fromRaw(List<int> value) {
    if (value.length < 15) return null;

    final address = _toIntLE(value.sublist(0, 3));
    final dataAddress = _toIntLE(value.sublist(3, 6));
    final packetType = value[6];
    final blobType = value[7];
    final packetSize = _toIntLE(value.sublist(8, 11));
    final timestamp = _toIntLE(value.sublist(11, 15));

    int ms = (value.length >= 17) ? _toIntLE(value.sublist(15, 17)) : 0;
    ms = ms > 999 ? 0 : ms;

    final createdAt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000 + ms, isUtc: true);

    int timestampClosed = 0, msClosed = 0;
    DateTime closedAt = createdAt;

    if (value.length >= 21) {
      timestampClosed = _toIntLE(value.sublist(17, 21));
      msClosed = (value.length >= 23) ? _toIntLE(value.sublist(21, 23)) : 0;
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
static List<PacketInfo> fromMultipleRaw(List<int> data) {
  final result = <PacketInfo>[];
  int offset = 0;

  while (offset + 15 <= data.length) {
    final remaining = data.sublist(offset);
    final packet = PacketInfo.fromRaw(remaining);

    if (packet == null || packet.packetSize <= 0) break;

    result.add(packet);
    offset += packet.packetSize;

    // Protección ante desbordamiento
    if (offset > data.length) break;
  }

  return result;
}

  static int _toIntLE(List<int> bytes) =>
      bytes.asMap().entries.fold(0, (sum, e) => sum | (e.value << (8 * e.key)));

  static Uint8List _toBytesLE(int value, int length) =>
      Uint8List.fromList(List.generate(length, (i) => (value >> (8 * i)) & 0xFF));

  @override
  List<Object?> get props => [
        address, dataAddress, packetType, blobType, packetSize,
        timestamp, ms, createdAt, timestampClosed, msClosed, closedAt
      ];

  @override
  String toString() => 'PacketInfo(size: $packetSize, ts: ${formatPgStyle(createdAt)})';
}

String formatPgStyle(DateTime date) {
  final formatted = DateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS").format(date.toUtc());
  return '$formatted+00:00';
}
