import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipmentpurchase.model.dart';

class EquipmentPurchaseService {
  final String baseUrl = 'http://localhost:3000/api/equipment-purchases';
  final http.Client client;

  EquipmentPurchaseService({required this.client});

  // Create a new equipment purchase
  Future<EquipmentPurchase?> createPurchase({
    required String userId,
    required String? equipmentId,
    required int quantity,
    required String token,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'user': userId,
          'equipment': equipmentId,
          'quantityPurchased': quantity,
        }),
      );

      if (response.statusCode == 201) {
        return EquipmentPurchase.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error creating purchase: $e');
      return null;
    }
  }

  // Get all purchases for a user
  Future<List<EquipmentPurchase>?> getUserPurchases(String userId, String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => EquipmentPurchase.fromJson(json)).toList();
      }
      return null;
    } catch (e) {
      print('Error fetching user purchases: $e');
      return null;
    }
  }

  // Get single purchase details
  Future<EquipmentPurchase?> getPurchaseDetails(String purchaseId, String token) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$purchaseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return EquipmentPurchase.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching purchase details: $e');
      return null;
    }
  }
}