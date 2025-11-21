class ConsumptionModel {
  late final int userId;
  late final String type;
  late final double amount;
  late final double sugarGrams;
  late final String context;

  ConsumptionModel({
    required this.userId,
    required this.type,
    required this.amount,
    required this.sugarGrams,
    required this.context,
  });

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "type": type,
      "amount": amount,
      "sugar_grams": sugarGrams,
      "context": context,
    };
  }
}
