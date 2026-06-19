import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:veins/src/core/models/user.dart';
import 'package:veins/src/features/employee/add_employee_page.dart';

class ManageEmployeesPage extends StatefulWidget {
  const ManageEmployeesPage({super.key});

  @override
  State<ManageEmployeesPage> createState() => _ManageEmployeesPageState();
}

class _ManageEmployeesPageState extends State<ManageEmployeesPage> {
  List<User> _employees = [];
  List<User> _filteredEmployees = [];
  String? _currentUserPosName;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final String response = await rootBundle.loadString('users.json');
    final data = await json.decode(response) as List;
    setState(() {
      _employees = data.map((json) => User.fromJson(json)).toList();
      // Assuming the current user is the first one in the list (admin)
      _currentUserPosName = _employees.isNotEmpty ? _employees.first.posName : null;
      _filterEmployees();
    });
  }

  void _filterEmployees() {
    if (_currentUserPosName == null) return;
    setState(() {
      _filteredEmployees = _employees
          .where((employee) => employee.posName == _currentUserPosName)
          .toList();
    });
  }

  void _navigateToAddEmployeePage() async {
    final newUser = await Navigator.of(context).push<User>(
      CupertinoPageRoute(
        builder: (context) => AddEmployeePage(orgName: _currentUserPosName),
      ),
    );

    if (newUser != null) {
      setState(() {
        _employees.add(newUser);
        _filterEmployees();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Manage Employees'),
      ),
      child: Stack(
        children: [
          if (_filteredEmployees.isEmpty)
            const Center(
              child: Text('No employees yet. Add one!'),
            )
          else
            GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = _filteredEmployees[index];
                return _buildEmployeeCard(employee);
              },
            ),
          Positioned(
            bottom: 32,
            right: 32,
            child: CupertinoButton(
              onPressed: _navigateToAddEmployeePage,
              padding: const EdgeInsets.all(20),
              color: CupertinoTheme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(35),
              child: const Icon(CupertinoIcons.add, size: 30, color: CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(User employee) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            employee.role == EmployeeRole.server
                ? CupertinoIcons.person_alt
                : CupertinoIcons.flame,
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            employee.username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            employee.role.toString().split('.').last.toUpperCase(),
            style: const TextStyle(fontSize: 12, color: CupertinoColors.systemGrey),
          ),
        ],
      ),
    );
  }
}
