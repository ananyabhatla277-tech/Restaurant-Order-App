import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:veins/src/core/models/order.dart';
import 'package:veins/src/features/orders/order_card.dart';

class CurrentOrdersPage extends StatefulWidget {
  const CurrentOrdersPage({super.key});

  @override
  State<CurrentOrdersPage> createState() => _CurrentOrdersPageState();
}

class _CurrentOrdersPageState extends State<CurrentOrdersPage> {
  List<Order>? _orders;
  final List<int> _doneOrderTableNumbers = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final String response = await rootBundle.loadString('Orders.json');
    final data = json.decode(response) as List;
    if (mounted) {
      setState(() {
        _orders = data.map((orderJson) => Order.fromJson(orderJson)).toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    }
  }

  void _markOrderAsDone(Order order) {
    setState(() {
      _doneOrderTableNumbers.add(order.tableNumber);
    });
  }

  void _revertLastDoneOrder() {
    if (_doneOrderTableNumbers.isNotEmpty) {
      setState(() {
        _doneOrderTableNumbers.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Current Orders'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _revertLastDoneOrder,
          child: const Icon(CupertinoIcons.arrow_uturn_left),
        ),
      ),
      child: SafeArea(
        child: _orders == null
            ? const Center(child: CupertinoActivityIndicator())
            : _orders!.isEmpty
                ? const Center(child: Text('No current orders.'))
                : ListView.builder(
                    itemCount: _orders!.length,
                    itemBuilder: (context, index) {
                      final order = _orders![index];
                      return OrderCard(
                        order: order,
                        isDone: _doneOrderTableNumbers.contains(order.tableNumber),
                        onMarkAsDone: () => _markOrderAsDone(order),
                      );
                    },
                  ),
      ),
    );
  }
}
