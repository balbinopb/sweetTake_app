// class DailyPoint {
//   final DateTime day;
//   final double sugar;
//   DailyPoint({required this.day, required this.sugar});

//   factory DailyPoint.fromJson(Map<String, dynamic> json) {
//     return DailyPoint(
//       day: DateTime.parse(json['day'] as String),
//       sugar: (json['sugar'] as num).toDouble(),
//     );
//   }
// }

// class WeeklyPoint {
//   final String week; // "YYYY-Www"
//   final double totalSugar;
//   final double avgPerDay;

//   WeeklyPoint({
//     required this.week,
//     required this.totalSugar,
//     required this.avgPerDay,
//   });

//   factory WeeklyPoint.fromJson(Map<String, dynamic> json) {
//     return WeeklyPoint(
//       week: json['week'] as String,
//       totalSugar: (json['total_sugar'] as num).toDouble(),
//       avgPerDay: (json['avg_per_day'] as num).toDouble(),
//     );
//   }
// }

// class MonthlyPoint {
//   final String month; // "YYYY-MM"
//   final double totalSugar;
//   final double avgPerDay;

//   MonthlyPoint({
//     required this.month,
//     required this.totalSugar,
//     required this.avgPerDay,
//   });

//   factory MonthlyPoint.fromJson(Map<String, dynamic> json) {
//     return MonthlyPoint(
//       month: json['month'] as String,
//       totalSugar: (json['total_sugar'] as num).toDouble(),
//       avgPerDay: (json['avg_per_day'] as num).toDouble(),
//     );
//   }
// }

// // Parsers
// List<DailyPoint> parseDaily(List<dynamic> arr) =>
//     arr.map((e) => DailyPoint.fromJson(e as Map<String, dynamic>)).toList();

// List<WeeklyPoint> parseWeekly(List<dynamic> arr) =>
//     arr.map((e) => WeeklyPoint.fromJson(e as Map<String, dynamic>)).toList();

// List<MonthlyPoint> parseMonthly(List<dynamic> arr) =>
//     arr.map((e) => MonthlyPoint.fromJson(e as Map<String, dynamic>)).toList();

class DailyPoint {
  final DateTime day;
  final double sugar;
  DailyPoint({required this.day, required this.sugar});
  factory DailyPoint.fromJson(Map<String, dynamic> json) => DailyPoint(
    day: DateTime.parse(json['day'] as String),
    sugar: (json['sugar'] as num).toDouble(),
  );
}

class WeeklyPoint {
  final String week;
  final double totalSugar;
  final double avgPerDay;
  WeeklyPoint({
    required this.week,
    required this.totalSugar,
    required this.avgPerDay,
  });
  factory WeeklyPoint.fromJson(Map<String, dynamic> json) => WeeklyPoint(
    week: json['week'] as String,
    totalSugar: (json['total_sugar'] as num).toDouble(),
    avgPerDay: (json['avg_per_day'] as num).toDouble(),
  );
}

class MonthlyPoint {
  final String month;
  final double totalSugar;
  final double avgPerDay;
  MonthlyPoint({
    required this.month,
    required this.totalSugar,
    required this.avgPerDay,
  });
  factory MonthlyPoint.fromJson(Map<String, dynamic> json) => MonthlyPoint(
    month: json['month'] as String,
    totalSugar: (json['total_sugar'] as num).toDouble(),
    avgPerDay: (json['avg_per_day'] as num).toDouble(),
  );
}

List<DailyPoint> parseDaily(List<dynamic> arr) =>
    arr.map((e) => DailyPoint.fromJson(e as Map<String, dynamic>)).toList();

List<WeeklyPoint> parseWeekly(List<dynamic> arr) =>
    arr.map((e) => WeeklyPoint.fromJson(e as Map<String, dynamic>)).toList();

List<MonthlyPoint> parseMonthly(List<dynamic> arr) =>
    arr.map((e) => MonthlyPoint.fromJson(e as Map<String, dynamic>)).toList();
