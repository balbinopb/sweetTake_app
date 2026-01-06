class HistoryConsumptionModel {
  final int consumptionId;
  final String type;
  final double amount;
  final double sugarData;
  final String context;
  final DateTime dateTime;

  HistoryConsumptionModel({
    required this.consumptionId,
    required this.type,
    required this.amount,
    required this.sugarData,
    required this.context,
    required this.dateTime,
  });

  factory HistoryConsumptionModel.fromJson(Map<String, dynamic> json) {
    return HistoryConsumptionModel(
      consumptionId: json['consumption_id'],
      dateTime: DateTime.parse(json['date_time']).toLocal(),
      type: json['type'] ?? 'Unknown',
      amount: (json['amount'] as num).toDouble(),
      sugarData: (json['sugar_data'] as num).toDouble(),
      context: json['context'] ?? '',
    );
  }

  String get time => '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

  DateTime get date => DateTime(dateTime.year, dateTime.month, dateTime.day);
}
