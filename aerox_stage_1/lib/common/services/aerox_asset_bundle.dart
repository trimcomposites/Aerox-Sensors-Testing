import 'dart:convert';

import 'package:aerox_stage_1/features/feature_login/ui/login_barrel.dart';
import 'package:flutter/services.dart';

class AeroxAssetBundle extends CachingAssetBundle{
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final ByteData data = await load(key);
    if (data == null) throw FlutterError('Unable to load asset');
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<ByteData> load(String key) async => rootBundle.load(key);
}
