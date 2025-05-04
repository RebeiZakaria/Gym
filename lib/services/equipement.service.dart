import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/equipement.model.dart';

class EquipmentService {
  final String baseUrl = 'http://localhost:3000/api/equipments'; // Update with your real API URL

  // Fetch all equipment
  Future<List<Equipment>> fetchAllEquipments() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => Equipment.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Failed to load equipments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching equipments: $e');
    }
  }

  // Add new equipment
  Future<void> addEquipment(Equipment equipment) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(equipment.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add equipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding equipment: $e');
    }
  }

  // Update equipment
  Future<void> updateEquipment(String id, Equipment equipment) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(equipment.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update equipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating equipment: $e');
    }
  }

  // Delete equipment
  Future<void> deleteEquipment(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete equipment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting equipment: $e');
    }
  }
}
