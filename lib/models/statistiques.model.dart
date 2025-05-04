class Statistics {
  final String id; // Add this for _id
  final DateTime date;
  final int totalEquipementsUtilises;
  final int tauxRemplissageCours;
  final int totalReservations;
  final List<PopularCourse> coursLesPlusPopulaires;
  final int? v; // For __v field

  Statistics({
    required this.date,
    required this.totalEquipementsUtilises,
    required this.tauxRemplissageCours,
    required this.totalReservations,
    required this.coursLesPlusPopulaires,
    required this.id,
    this.v,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      totalEquipementsUtilises: json['totalEquipementsUtilises'],
      tauxRemplissageCours: json['tauxRemplissageCours'],
      totalReservations: json['totalReservations'],
      coursLesPlusPopulaires: List<PopularCourse>.from(
          json['coursLesPlusPopulaires'].map((x) => PopularCourse.fromJson(x))),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'totalEquipementsUtilises': totalEquipementsUtilises,
      'tauxRemplissageCours': tauxRemplissageCours,
      'totalReservations': totalReservations,
      'coursLesPlusPopulaires':
      coursLesPlusPopulaires.map((x) => x.toJson()).toList(),
      '__v': v,
    };
  }
}

class PopularCourse {
  final String courseId;
  final String titre;
  final int reservations;
  final String id; // For _id field

  PopularCourse({
    required this.courseId,
    required this.titre,
    required this.reservations,
    required this.id,
  });

  factory PopularCourse.fromJson(Map<String, dynamic> json) {
    return PopularCourse(
      courseId: json['courseId'],
      titre: json['titre'],
      reservations: json['reservations'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'titre': titre,
      'reservations': reservations,
      '_id': id,
    };
  }
}