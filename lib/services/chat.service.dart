import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl;

  ChatService({this.baseUrl = 'http://localhost:3000'});

  // Method to send a message with userId
  Future<String> sendMessage(String message, String? userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return data['reply'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getConversation(String? userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/conversation/$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);


        if (data['messages'] is List) {
          return List<Map<String, dynamic>>.from(data['messages']);
        } else {
          throw Exception('Unexpected data format: messages key not a list');
        }
      } else {
        throw Exception('Failed to load conversation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching conversation: $e');
    }
  }

}
