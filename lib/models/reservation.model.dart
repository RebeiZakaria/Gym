import 'course.model.dart';

class Reservation {
  final String id;
  final String userId;
  final String course;
  final DateTime sessionDate;
  final String? notes;
  final String status;

  Reservation({
    required this.id,
    required this.userId,
    required this.course,
    required this.sessionDate,
    this.notes,
    required this.status,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['_id'] as String,
      userId: json['user'] as String,
      course: json['course'] as String ,
      sessionDate: DateTime.parse(json['sessionDate']),
      notes: json['notes'],
      status: json['status'],
    );
  }
}