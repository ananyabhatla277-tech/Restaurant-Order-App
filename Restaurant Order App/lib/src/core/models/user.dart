import 'package:veins/src/core/models/menu_item.dart';
enum EmployeeRole { server, cook, admin }

class User {
  final String username;
  final String password;
  final bool isAdmin;
  final String? posName;
  final List<MenuItem> menuItems;
  String theme;
  final int? numServed;
  final int? numCooked;
  final EmployeeRole? role; 

  User({
    required this.username,
    required this.password,
    required this.isAdmin,
    this.posName,
    this.menuItems = const [],
    this.theme = 'light',
    this.numServed,
    this.numCooked,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var menuItemsList = <MenuItem>[];
    if (json['menuItems'] != null && json['isAdmin'] == true) {
      menuItemsList = (json['menuItems'] as List)
          .map((itemJson) => MenuItem.fromJson(itemJson))
          .toList();
    }

    return User(
      username: json['username'],
      password: json['password'],
      isAdmin: json['isAdmin'],
      posName: json['OrgName'],
      menuItems: menuItemsList,
      theme: json['theme'] ?? 'light',
      numServed: json['numServed'],
      numCooked: json['numCooked'],
      role: json['role'] != null
          ? EmployeeRole.values.firstWhere(
              (e) => e.toString() == 'EmployeeRole.${json['role']}')
          : null,
    );
  }
}
