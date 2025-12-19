

class ConsumptionGraphModel {
  final DateTime dateTime;
  final double sugar;

  ConsumptionGraphModel({
    required this.dateTime,
    required this.sugar,
  });

  factory ConsumptionGraphModel.fromJson(Map<String, dynamic> json) {
    return ConsumptionGraphModel(
      dateTime: DateTime.parse(json['date_time']),
      sugar: (json['sugar_data'] as num).toDouble(),
    );
  }
}
