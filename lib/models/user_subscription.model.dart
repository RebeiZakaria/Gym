class UserSubscription {
  final String id;
  final String userId;
  final String subscriptionPlanId;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;

  UserSubscription({
    required this.id,
    required this.userId,
    required this.subscriptionPlanId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['_id'],
      userId: json['user'],
      subscriptionPlanId: json['subscriptionPlan'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'subscriptionPlan': subscriptionPlanId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
    };
  }
}