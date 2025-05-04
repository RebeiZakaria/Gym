import 'dart:convert';
import 'package:http/http.dart' as http;import '../models/statistiques.model.dart';


class StatisticsService {
  final String baseUrl = "http://localhost:3000/api/statistiques";

  StatisticsService();

  Future<Statistics> generateStatistics() async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Statistics.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to generate statistics: ${json.decode(response.body)['message']}');
    }
  }

  Future<List<Statistics>> getAllStatistics() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Statistics.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load statistics: ${json.decode(response.body)['message']}');
    }
  }

  Future<Statistics> getCurrentStatistics() async {
    final response = await http.get(
      Uri.parse('$baseUrl/current'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Statistics.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load current statistics: ${json.decode(response.body)['message']}');
    }
  }
}