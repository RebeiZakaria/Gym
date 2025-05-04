class EquipmentPurchase {
  final String id;
  final String userId;
  final String equipmentId;
  final int quantity;
  final double totalPrice;
  final DateTime purchaseDate;

  EquipmentPurchase({
    required this.id,
    required this.userId,
    required this.equipmentId,
    required this.quantity,
    required this.totalPrice,
    required this.purchaseDate,
  });

  factory EquipmentPurchase.fromJson(Map<String, dynamic> json) {
    return EquipmentPurchase(
      id: json['_id'] as String,
      userId: json['user'] as String,
      equipmentId: json['equipment'],
      quantity: json['quantityPurchased'],
      totalPrice: json['totalPrice'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
    );
  }
}