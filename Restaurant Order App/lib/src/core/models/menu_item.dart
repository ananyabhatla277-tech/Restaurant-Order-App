class MenuItem {
  final String name;
  final List<String> photoUrls;
  final String description;
  final double price;

  MenuItem({
    required this.name,
    required this.photoUrls,
    required this.description,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] ?? 'Unknown Item',
      photoUrls: json['photoUrls'] != null ? List<String>.from(json['photoUrls']) : [],
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}
