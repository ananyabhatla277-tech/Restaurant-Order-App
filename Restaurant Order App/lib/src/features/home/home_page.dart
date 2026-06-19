import 'package:fl_chart/fl_chart.dart';
import 'package:veins/src/features/employee/manage_employees_page.dart';
import 'package:veins/src/features/orders/current_orders_page.dart';
import 'package:veins/src/features/menu/manage_menu_page.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/models/user.dart';

class HomePage extends StatefulWidget {
  final User user;
  final VoidCallback toggleTheme;

  const HomePage({super.key, required this.user, required this.toggleTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _rightAnimationController;
  late AnimationController _leftAnimationController;
  bool _isRightSidebarOpen = false;
  bool _isLeftSidebarOpen = false;
  double _totalRevenue = 0.0;
  Map<String, double> _employeeContributions = {};

  @override
  void initState() {
    super.initState();
    _rightAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _leftAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _calculateTotalRevenue();
    _calculateEmployeeContributions();
  }

  Future<void> _calculateTotalRevenue() async {
    final String response = await rootBundle.loadString('orders.json');
    final List<dynamic> data = json.decode(response);
    double total = 0.0;
    for (var order in data) {
      for (var item in order['menu_items']) {
        total += item['price'];
      }
    }
    setState(() {
      _totalRevenue = total;
    });
  }

  Future<void> _calculateEmployeeContributions() async {
    final String usersResponse = await rootBundle.loadString('users.json');
    final List<dynamic> usersData = json.decode(usersResponse);
    final Map<String, double> employeeContributions = {};

    for (var user in usersData) {
      if (!user['isAdmin']) {
        final String username = user['username'];
        final double numServed = (user['numServed'] ?? 0).toDouble();
        final double numCooked = (user['numCooked'] ?? 0).toDouble();
        employeeContributions[username] = numServed + numCooked;
      }
    }

    setState(() {
      _employeeContributions = employeeContributions;
    });
  }

  @override
  void dispose() {
    _rightAnimationController.dispose();
    _leftAnimationController.dispose();
    super.dispose();
  }

  void _toggleRightSidebar() {
    setState(() {
      if (_isLeftSidebarOpen) {
        _isLeftSidebarOpen = false;
        _leftAnimationController.reverse();
      }
      _isRightSidebarOpen = !_isRightSidebarOpen;
      if (_isRightSidebarOpen) {
        _rightAnimationController.forward();
      } else {
        _rightAnimationController.reverse();
      }
    });
  }

  void _toggleLeftSidebar() {
    setState(() {
      if (_isRightSidebarOpen) {
        _isRightSidebarOpen = false;
        _rightAnimationController.reverse();
      }
      _isLeftSidebarOpen = !_isLeftSidebarOpen;
      if (_isLeftSidebarOpen) {
        _leftAnimationController.forward();
      } else {
        _leftAnimationController.reverse();
      }
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final sidebarWidth = MediaQuery.of(context).size.width * 0.75;
    if (details.primaryDelta! < 0) {
      _rightAnimationController.value -= details.primaryDelta! / sidebarWidth;
    } else {
      _leftAnimationController.value += details.primaryDelta! / sidebarWidth;
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_rightAnimationController.value >= 0.5) {
      _rightAnimationController.forward();
      _isRightSidebarOpen = true;
    } else {
      _rightAnimationController.reverse();
      _isRightSidebarOpen = false;
    }

    if (_leftAnimationController.value >= 0.5) {
      _leftAnimationController.forward();
      _isLeftSidebarOpen = true;
    } else {
      _leftAnimationController.reverse();
      _isLeftSidebarOpen = false;
    }
  }

  Widget _buildLeftSidebar() {
    final sidebarWidth = MediaQuery.of(context).size.width * 0.75;
    return SafeArea(
      child: Container(
        width: sidebarWidth,
        color: CupertinoTheme.of(
          context,
        ).scaffoldBackgroundColor.withAlpha(230),
        child: CupertinoListSection.insetGrouped(
          backgroundColor: CupertinoColors.transparent,
          header: const Text('Menu'),
          children: [
            CupertinoListTile(
              title: const Text('Manage Menu'),
              leading: const Icon(CupertinoIcons.list_bullet),
              onTap: () {
                _toggleLeftSidebar();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        ManageMenuPage(menuItems: widget.user.menuItems),
                  ),
                );
              },
            ),
            CupertinoListTile(
              title: const Text('Manage Employees'),
              leading: const Icon(CupertinoIcons.person_2),
              onTap: () {
                _toggleLeftSidebar();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ManageEmployeesPage(),
                  ),
                );
              },
            ),
            CupertinoListTile(
              title: const Text('Current Orders'),
              leading: const Icon(CupertinoIcons.square_list),
              onTap: () {
                _toggleLeftSidebar();
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const CurrentOrdersPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: CupertinoTheme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _employeeContributions.values.isEmpty
              ? 1
              : _employeeContributions.values.reduce((a, b) => a > b ? a : b) *
                    1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String weekDay = _employeeContributions.keys.elementAt(
                  group.x.toInt(),
                );
                return BarTooltipItem(
                  '$weekDay\n',
                  const TextStyle(
                    color: CupertinoColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: rod.toY.toInt().toString(),
                      style: const TextStyle(
                        color: CupertinoColors.systemYellow,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final style = TextStyle(
                    color: CupertinoTheme.of(context).textTheme.textStyle.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  );
                  Widget text = Text(
                    _employeeContributions.keys.elementAt(value.toInt()),
                    style: style,
                  );
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 16.0,
                    angle: -0.5,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _employeeContributions.entries
              .map(
                (entry) => BarChartGroupData(
                  x: _employeeContributions.keys.toList().indexOf(entry.key),
                  barRods: [
                    BarChartRodData(
                      toY: entry.value,
                      color: CupertinoColors.activeBlue,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sidebarWidth = screenWidth * 0.75;

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _toggleLeftSidebar,
            child: const Icon(CupertinoIcons.bars),
          ),
          middle: const Text('Home'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _toggleRightSidebar,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.profile_circled),
                const SizedBox(width: 4),
                Text(widget.user.username),
              ],
            ),
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Align(
              alignment: Alignment.topCenter,
              child: widget.user.isAdmin
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: CupertinoTheme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12.0),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemGrey.withOpacity(
                                    0.2,
                                  ),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Total Revenue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoTheme.of(
                                      context,
                                    ).primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${_totalRevenue.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: CupertinoColors.activeGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Employee Contributions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CupertinoTheme.of(context).primaryColor,
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: _buildBarChart(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('Welcome!')),
            ),
            // Blur effect for right sidebar
            AnimatedBuilder(
              animation: _rightAnimationController,
              builder: (context, child) {
                if (_rightAnimationController.value == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: _toggleRightSidebar,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _rightAnimationController.value * 5,
                      sigmaY: _rightAnimationController.value * 5,
                    ),
                    child: Container(
                      color: CupertinoColors.black.withAlpha(51),
                    ),
                  ),
                );
              },
            ),
            // Blur effect for left sidebar
            AnimatedBuilder(
              animation: _leftAnimationController,
              builder: (context, child) {
                if (_leftAnimationController.value == 0) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: _toggleLeftSidebar,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _leftAnimationController.value * 5,
                      sigmaY: _leftAnimationController.value * 5,
                    ),
                    child: Container(
                      color: CupertinoColors.black.withAlpha(51),
                    ),
                  ),
                );
              },
            ),
            // Right Sidebar
            AnimatedBuilder(
              animation: _rightAnimationController,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  right: sidebarWidth * (_rightAnimationController.value - 1),
                  child: child!,
                );
              },
              child: SafeArea(
                child: Container(
                  width: sidebarWidth,
                  color: CupertinoTheme.of(
                    context,
                  ).scaffoldBackgroundColor.withAlpha(230),
                  child: Column(
                    children: [
                      CupertinoListSection.insetGrouped(
                        backgroundColor: CupertinoColors.transparent,
                        header: Text('Welcome, ${widget.user.username}'),
                        children: [
                          CupertinoListTile(
                            title: const Text('Settings'),
                            leading: const Icon(CupertinoIcons.settings),
                            onTap: () {
                              _toggleRightSidebar();
                              // TODO: Navigate to settings
                            },
                          ),
                          CupertinoListTile(
                            title: const Text('Toggle Theme'),
                            leading: const Icon(CupertinoIcons.sun_max),
                            onTap: () {
                              widget.toggleTheme();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Left Sidebar
            AnimatedBuilder(
              animation: _leftAnimationController,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  left: sidebarWidth * (_leftAnimationController.value - 1),
                  child: child!,
                );
              },
              child: _buildLeftSidebar(),
            ),
          ],
        ),
      ),
    );
  }
}
