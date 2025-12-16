class ConsumptionModel {
  final String type;
  final double amount;
  final double sugarData;
  final String context;
  final String dateTime;

  ConsumptionModel({
    required this.type,
    required this.amount,
    required this.sugarData,
    required this.context,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "amount": amount,
    "sugar_data": sugarData,
    "context": context,
    "date_time": dateTime,
  };
}
