class Equipment {
  final String? id;
  final String name;
  final String? description; // Nouveau champ
  final int quantity;
  final double price;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Equipment({
    this.id,
    required this.name,
    this.description,
    required this.quantity,
    required this.price,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'image': image,
    };
  }
}