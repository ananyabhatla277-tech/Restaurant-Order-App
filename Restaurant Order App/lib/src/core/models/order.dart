import 'dart:convert';

class Order {
  final int tableNumber;
  final DateTime timestamp;
  final List<MenuItem> menuItems;

  Order({
    required this.tableNumber,
    required this.timestamp,
    required this.menuItems,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      tableNumber: json['table_number'],
      timestamp: DateTime.parse(json['timestamp']),
      menuItems: (json['menu_items'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

class MenuItem {
  final String name;
  final double price;

  MenuItem({
    required this.name,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
}

List<Order> parseOrders(String jsonString) {
  final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}