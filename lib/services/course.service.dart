import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.model.dart';

class CourseService {
  final String baseUrl = 'http://localhost:3000/api/courses'; // Adaptez selon votre configuration
  final http.Client client;

  CourseService({required this.client});

  Future<List<Course>> fetchAllCourses() async {
    final response = await client.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((jsonItem) => Course.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  Future<Course> createCourse(Course course) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );

    if (response.statusCode == 201) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create course: ${response.statusCode}');
    }
  }

  Future<Course> updateCourse(String id, Course course) async {
    final response = await client.patch(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(course.toJson()),
    );

    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update course: ${response.statusCode}');
    }
  }

  Future<void> deleteCourse(String id) async {
    final response = await client.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete course: ${response.statusCode}');
    }
  }

  Future<List<Course>> getFutureCourses() async {
    final response = await client.get(
      Uri.parse('$baseUrl/future'), // Matches your backend endpoint
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((jsonItem) => Course.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load future courses: ${response.statusCode}');
    }
  }
}