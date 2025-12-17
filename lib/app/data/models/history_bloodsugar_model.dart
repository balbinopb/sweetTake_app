
class HistoryBloodsugarModel {
  final DateTime dateTime;
  final double bloodSugarData;
  final String context;

  HistoryBloodsugarModel({
    required this.dateTime,
    required this.bloodSugarData,
    required this.context,
  });

  factory HistoryBloodsugarModel.fromJson(Map<String, dynamic> json) {
    return HistoryBloodsugarModel(
      dateTime: DateTime.parse(json['date_time']),
      bloodSugarData: (json['blood_sugar'] as num).toDouble(),
      context: json['context'] ?? '',
    );
  }
}
