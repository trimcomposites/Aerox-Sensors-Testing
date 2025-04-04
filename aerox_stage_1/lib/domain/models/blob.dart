class Blob {
  final int address;
  final int blobType;
  final int blobNumPackets;
  final int blobSize;
  final int extraDataLen;
  final List<int> extraData;

  final List<BlobPacket> packets;
  final DateTime? createdAt;
  final DateTime? closedAt;

  const Blob({
    required this.address,
    required this.blobType,
    required this.blobNumPackets,
    required this.blobSize,
    required this.extraDataLen,
    required this.extraData,
    this.packets = const [],
    this.createdAt,
    this.closedAt,
  });

  @override
  String toString() {
    return '''
  🔹 Blob
    • Address: $address
    • Type: $blobType
    • Size: $blobSize bytes
    • NumPackets (expected): $blobNumPackets
    • ExtraDataLen: $extraDataLen → ${extraData.isEmpty ? "EMPTY" : extraData}
    • Packets (actual): ${packets.length}
    • CreatedAt: ${createdAt ?? "N/A"}
    • ClosedAt: ${closedAt ?? "N/A"}
  ''';
  }

}
class BlobPacket {
  final PacketInfo packetInfo;
  final List<int> packetData;

  BlobPacket({
    required this.packetInfo,
    required this.packetData,
  });

  int get packetNumber => packetInfo.timestamp; // puedes personalizar esto
}
class PacketInfo {
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

  PacketInfo({
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

  int get endAddress => address + packetSize - 1;
  int get headerSize => dataAddress - address;
  int get dataSize => packetSize - headerSize;

  @override
  String toString() => 'PacketInfo(addr: $address, size: $packetSize, timestamp: $createdAt)';
}
