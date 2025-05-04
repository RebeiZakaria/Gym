import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification.model.dart';

class NotificationService {
  final String baseUrl;


  NotificationService({
    this.baseUrl = 'http://localhost:3000/api',

  });

  Future<List<NotificationModel>> getUserNotifications(String? userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/$userId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to get notifications: ${e.toString()}');
    }
  }

  Future<NotificationModel> markAsRead(String notificationId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return NotificationModel.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to mark as read: ${e.toString()}');
    }
  }

  Future<int> markAllAsRead(String? userId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/notifications/user/$userId/mark-all-read'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['modifiedCount'] ?? 0;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to mark all as read: ${e.toString()}');
    }
  }

  Future<bool> hasUnreadNotifications(String? userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications/user/$userId/has-unread'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['hasUnread'] ?? false;
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Failed to check unread notifications: ${e.toString()}');
    }
  }

  Map<String, String> _buildHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };


    return headers;
  }

  Exception _handleError(http.Response response) {
    try {
      final errorData = json.decode(response.body);
      return Exception(errorData['message'] ?? 'Unknown error occurred');
    } catch (_) {
      return Exception('Request failed with status: ${response.statusCode}');
    }
  }
}