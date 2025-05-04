import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_subscription.model.dart';

class UserSubscriptionService {
  final String baseUrl = 'http://localhost:3000/api/user-subscriptions';
  final http.Client client;

  UserSubscriptionService({required this.client});

  Future<UserSubscription> createSubscription({
    required String userId,
    required String planType,
  }) async {

    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user': userId,
          'planType': planType,
        }),
      );

      if (response.statusCode == 201) {
        return UserSubscription.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create subscription: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating subscription: $e');
    }
  }
}