

class HistoryConsumptionModel {
  final String type;
  final double amount;
  final double sugarData;
  final String context;
  final DateTime dateTime;

  HistoryConsumptionModel({
    required this.type,
    required this.amount,
    required this.sugarData,
    required this.context,
    required this.dateTime,
  });



  factory HistoryConsumptionModel.fromJson(Map<String, dynamic> json) {
    return HistoryConsumptionModel(
      dateTime: DateTime.parse(json['date_time']),
      type: json['type'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      sugarData: (json['sugar_data'] as num).toDouble(),
      context: json['context'] ?? '',
    );
  }
}
