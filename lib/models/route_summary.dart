class RouteSummary {
  final String algorithmName;
  final double totalDistance;
  final double totalCarbon;
  final int calculationTime;
  final double fitnessScore;

  RouteSummary({
    required this.algorithmName,
    required this.totalDistance,
    required this.totalCarbon,
    required this.calculationTime,
    required this.fitnessScore,
  });

  factory RouteSummary.fromJson(Map<String, dynamic> json) {
    return RouteSummary(
      algorithmName: json['algorithmName'] ?? '-',
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0,
      totalCarbon: (json['totalCarbon'] as num?)?.toDouble() ?? 0,
      calculationTime: (json['calculationTime'] as num?)?.toInt() ?? 0,
      fitnessScore: (json['fitnessScore'] as num?)?.toDouble() ?? 0,
    );
  }
}