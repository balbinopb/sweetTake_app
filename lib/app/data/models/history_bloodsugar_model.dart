
class HistoryBloodsugarModel {
  final int metricId;
  final DateTime dateTime;
  final double bloodSugarData;
  final String context;

  HistoryBloodsugarModel({
    required this .metricId,
    required this.dateTime,
    required this.bloodSugarData,
    required this.context,
  });

  factory HistoryBloodsugarModel.fromJson(Map<String, dynamic> json) {
    return HistoryBloodsugarModel(
      metricId: json['metric_id'],
      dateTime: DateTime.parse(json['date_time']).toLocal(),
      bloodSugarData: (json['blood_sugar'] as num).toDouble(),
      context: json['context'] ?? '',
    );
  }
}
