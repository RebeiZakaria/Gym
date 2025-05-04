class NotificationModel {
  final String id;
  final String userId;
  final String? reservationId;
  final NotificationType type;
  final String title;
  final String message;
  final bool read;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.userId,
    this.reservationId,
    required this.type,
    required this.title,
    required this.message,
    this.read = false,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['user'],
      reservationId: json['reservation'],
      type: _parseNotificationType(json['type']),
      title: json['title'],
      message: json['message'],
      read: json['read'] ?? false,
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'reservation': reservationId,
      'type': type.toString().split('.').last,
      'title': title,
      'message': message,
      'read': read,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static NotificationType _parseNotificationType(String type) {
    switch (type) {
      case 'created':
        return NotificationType.created;
      case 'updated':
        return NotificationType.updated;
      case 'cancelled':
        return NotificationType.cancelled;
      case 'reminder':
        return NotificationType.reminder;
      default:
        throw Exception('Unknown notification type: $type');
    }
  }
}

enum NotificationType {
  created,
  updated,
  cancelled,
  reminder,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.created:
        return 'Created';
      case NotificationType.updated:
        return 'Updated';
      case NotificationType.cancelled:
        return 'Cancelled';
      case NotificationType.reminder:
        return 'Reminder';
    }
  }
}