import 'package:aerox_stage_1/domain/models/blob.dart';

extension BlobExtension on List<int> {
  Blob? toBlob() {
    final packetInfo = PacketInfo.fromRaw(this);
    if (packetInfo == null) return null;

    final expectedHeaderLength = 23; 
    if (length <= expectedHeaderLength) return null;

    final dataStart = packetInfo.dataAddress - packetInfo.address;
    final packetData = length > dataStart ? sublist(dataStart) : <int>[];

    return Blob(
      packetInfo: packetInfo,
      packetData: packetData,
    );
  }
}
