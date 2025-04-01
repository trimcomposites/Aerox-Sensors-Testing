class Session {
  final String sessionId;
  final DateTime timestamp;
  final Map<String, List<int>> sensorData;

  Session({
    required this.sessionId,
    required this.timestamp,
    required this.sensorData,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'timestamp': timestamp.toIso8601String(),
      'sensorData': sensorData,
    };
  }
}
