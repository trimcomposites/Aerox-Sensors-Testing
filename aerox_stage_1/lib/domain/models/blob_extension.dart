import 'package:aerox_stage_1/domain/models/blob.dart';

extension BlobExtension on List<int> {
  Blob? toBlob() {
    if (length < 10) return null;

    final address = this[0] | (this[1] << 8) | (this[2] << 16);
    final blobType = this[3];
    final blobNumPackets = this[4] | (this[5] << 8);
    final blobSize = this[6] | (this[7] << 8) | (this[8] << 16);
    final extraDataLen = this[9];

    final List<int> extraData = (extraDataLen > 0 && length >= 10 + extraDataLen)
        ? sublist(10, 10 + extraDataLen)
        : [];

    return Blob(
      address: address,
      blobType: blobType,
      blobNumPackets: blobNumPackets,
      blobSize: blobSize,
      extraDataLen: extraDataLen,
      extraData: extraData,
      packets: const [], 
      createdAt: null,
      closedAt: null,
    );
  }
  
}
