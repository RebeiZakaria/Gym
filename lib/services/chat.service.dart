import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl;

  ChatService({this.baseUrl = 'http://localhost:3000'});

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/chat'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] as String;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return data['reply'] as String;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}