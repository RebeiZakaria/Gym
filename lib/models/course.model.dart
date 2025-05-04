import 'package:intl/intl.dart';

class Course {
  final String? id;
  final String title;
  final String coach;
  final String description;
  final DateTime schedule;  // Déclaration correcte du champ
  final int capacity;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Course({
    this.id,
    required this.title,
    required this.coach,
    required this.description,
    required this.schedule,  // Champ requis dans le constructeur
    required this.capacity,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'],
      title: json['title'],
      coach: json['coach'],
      description: json['description'],
      schedule: DateTime.parse(json['schedule']),  // Conversion depuis String ISO
      capacity: json['capacity'],
      image: json['image'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'coach': coach,
      'description': description,
      'schedule': schedule.toIso8601String(),  // Conversion en String ISO
      'capacity': capacity,
      'image': image,
    };
  }

  // Méthodes d'affichage formaté
  String get formattedDate {
    return DateFormat.yMMMMd('fr').format(schedule);
  }

  String get formattedTime {
    return DateFormat.Hm('fr').format(schedule);
  }

  String get formattedSchedule {
    return '$formattedDate à $formattedTime';
  }
}