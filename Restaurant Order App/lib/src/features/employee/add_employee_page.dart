import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/models/user.dart';

class AddEmployeePage extends StatefulWidget {
  final String? orgName;
  const AddEmployeePage({super.key, this.orgName});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  EmployeeRole? _selectedRole;

  void _selectRole(EmployeeRole role) {
    setState(() {
      _selectedRole = role;
    });
  }

  void _createEmployee() {
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _selectedRole != null) {
      final newUser = User(
        username: _usernameController.text,
        password: _passwordController.text,
        role: _selectedRole!,
        posName: widget.orgName,
        isAdmin: false,
      );
      Navigator.of(context).pop(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add Employee'),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                CupertinoFormSection.insetGrouped(
                  backgroundColor: CupertinoColors.transparent,
                  header: const Text('EMPLOYEE CREDENTIALS'),
                  children: [
                    CupertinoTextField(
                      controller: _usernameController,
                      placeholder: 'Username',
                      prefix: const Icon(CupertinoIcons.person_solid),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                      prefix: const Icon(CupertinoIcons.lock_fill),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'ROLE',
                    style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRoleBox(
                      role: EmployeeRole.server,
                      icon: CupertinoIcons.person_alt,
                      description: 'Manages tables and orders.',
                    ),
                    _buildRoleBox(
                      role: EmployeeRole.cook,
                      icon: CupertinoIcons.flame,
                      description: 'Prepares and cooks food.',
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CupertinoButton.filled(
                    onPressed: _createEmployee,
                    child: const Text('Create Employee'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBox({
    required EmployeeRole role,
    required IconData icon,
    required String description,
  }) {
    final isSelected = _selectedRole == role;
    final theme = CupertinoTheme.of(context);
    return GestureDetector(
      onTap: () => _selectRole(role),
      child: Container(
        width: 150,
        height: 180,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.2)
              : theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : CupertinoColors.systemGrey.withOpacity(0.3),
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color: isSelected
                    ? theme.primaryColor
                    : theme.textTheme.textStyle.color),
            const SizedBox(height: 12),
            Text(
              role.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? theme.primaryColor
                    : theme.textTheme.textStyle.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
