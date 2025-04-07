import 'package:aerox_stage_1/domain/models/blob.dart';
import 'package:flutter/services.dart';

extension BlobInfoConverter on List<int> {
  BlobInfo? toBlobInfo() {
    if (length < 10) return null;
    
    return BlobInfo(
      address: _bytesToUInt(sublist(0, 3)),
      blobType: this[3],
      blobNumPackets: _bytesToUInt(sublist(4, 6)),
      blobSize: _bytesToUInt(sublist(6, 9)),
      extraDataLen: this[9],
      extraData: length > 10 ? sublist(10, 10 + this[9])  as Uint8List : null
      ,
    );
  }
  
  static int _bytesToUInt(List<int> bytes) {
    int result = 0;
    for (int i = 0; i < bytes.length; i++) {
      result |= (bytes[i] << (8 * i));
    }
    return result;
  }
}