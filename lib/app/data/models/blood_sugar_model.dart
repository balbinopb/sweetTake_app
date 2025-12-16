class BloodSugarModel {
  final String dateTime;
  final double bloodSugarData;
  final String context;

  BloodSugarModel({
    required this.bloodSugarData,
    required this.context,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
    "date_time": dateTime,
    "blood_sugar": bloodSugarData,
    "context": context,
  };
}
