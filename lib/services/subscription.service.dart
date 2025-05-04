import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/subscription_plan.model.dart';

class SubscriptionService {
  final String baseUrl = 'http://localhost:3000/api/subscription-plans';
  final http.Client client;

  SubscriptionService({required this.client});

  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final response = await client.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final plans = data.map((json) => SubscriptionPlan.fromJson(json)).toList();

        // Triez les plans selon l'ordre souhaité
        plans.sort((a, b) {
          const order = ['monthly', 'quarterly', 'semi-annual', 'annual'];
          return order.indexOf(a.planType).compareTo(order.indexOf(b.planType));
        });

        return plans;
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plans: $e');
    }
  }
}