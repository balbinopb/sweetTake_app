// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<List<dynamic>> fetchDataPointsArray(String url) async {
//   final res = await http.get(Uri.parse(url));
//   if (res.statusCode != 200) {
//     throw Exception('Failed to load: ${res.statusCode}');
//   }

//   final body = jsonDecode(res.body);
//   // If body is an array: return it
//   if (body is List<dynamic>) {
//     return body;
//   }
//   // If body is an object with "data_points" array:
//   if (body is Map<String, dynamic> && body['data_points'] is List<dynamic>) {
//     return body['data_points'] as List<dynamic>;
//   }
//   throw Exception('Unexpected response shape');
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Fetches chart `data_points` as a JSON array.
/// Supports two backend shapes:
/// 1) Array: [ {...}, {...} ]
/// 2) Object with "data_points": { "graph_type": "...", "data_points": [ ... ] }
Future<List<dynamic>> fetchDataPointsArray(String url) async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    throw Exception('Failed to load (${res.statusCode}) from $url');
  }
  final body = jsonDecode(res.body);

  if (body is List<dynamic>) {
    return body;
  }
  if (body is Map<String, dynamic> && body['data_points'] is List<dynamic>) {
    return body['data_points'] as List<dynamic>;
  }
  throw Exception('Unexpected response shape from $url');
}
