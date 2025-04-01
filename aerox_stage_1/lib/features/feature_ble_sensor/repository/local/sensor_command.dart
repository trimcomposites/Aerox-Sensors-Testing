enum SensorCommand { readMem, startStream, stopStream }

extension SensorCommandExt on SensorCommand {
  String get raw {
    switch (this) {
      case SensorCommand.readMem: return 'READ_MEM';
      case SensorCommand.startStream: return 'START_STREAM';
      case SensorCommand.stopStream: return 'STOP_STREAM';
    }
  }
}
