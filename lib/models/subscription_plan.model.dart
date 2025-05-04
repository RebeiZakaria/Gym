class SubscriptionPlan {
  final String id;
  final String planType;
  final double price;
  final int durationDays;
  final String description;

  SubscriptionPlan({
    required this.id,
    required this.planType,
    required this.price,
    required this.durationDays,
    required this.description,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['_id'],
      planType: json['planType'],
      price: (json['price'] as num).toDouble(),
      durationDays: json['durationDays'],
      description: json['description'] ?? '',
    );
  }
}