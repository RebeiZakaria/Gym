import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.model.dart';
import '../models/course.model.dart';
import '../models/user.model.dart';

class ReservationService {
  final String baseUrl;
  final http.Client client;

  ReservationService({
    required this.client,
    this.baseUrl = 'http://localhost:3000/api/reservations',
  });

  // Create a new reservation
  Future<Reservation?> createReservation({
    required String userId,
    required String? courseId,
    required DateTime sessionDate,
    String? notes,
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
          'user_id': userId,
          'courseId': courseId,
          'sessionDate': sessionDate.toIso8601String(),
          'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        return Reservation.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body)['message'] ?? 'Failed to create reservation';
        throw Exception(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update an existing reservation
  Future<Reservation?> updateReservation({
    required String reservationId,
    required DateTime sessionDate,
    String? notes,
    required String token,
  }) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/$reservationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'sessionDate': sessionDate.toIso8601String(),
          'notes': notes,
        }),
      );

      if (response.statusCode == 200) {
        return Reservation.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body)['message'] ?? 'Failed to update reservation';
        throw Exception(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cancel a reservation
  Future<bool> cancelReservation({
    required String reservationId,
    required String token,
  }) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/$reservationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final error = json.decode(response.body)['message'] ?? 'Failed to cancel reservation';
        throw Exception(error);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get user's reservations
  Future<List<Reservation>> getUserReservations({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Reservation.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get reservation details
  Future<Reservation> getReservationDetails({
    required String reservationId,
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$reservationId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Reservation.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load reservation details');
      }
    } catch (e) {
      rethrow;
    }
  }
}