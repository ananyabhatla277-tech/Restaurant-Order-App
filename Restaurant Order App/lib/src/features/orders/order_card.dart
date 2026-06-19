import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/models/order.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final VoidCallback onMarkAsDone;
  final bool isDone;

  const OrderCard({
    super.key,
    required this.order,
    required this.onMarkAsDone,
    this.isDone = false,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;
  late Set<int> _doneItems;

  @override
  void initState() {
    super.initState();
    _doneItems = <int>{};
  }

  void _toggleDone(int itemIndex) {
    setState(() {
      if (_doneItems.contains(itemIndex)) {
        _doneItems.remove(itemIndex);
      } else {
        _doneItems.add(itemIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final isExpanded = _isExpanded;
    final isCardDone = widget.isDone;

    return Opacity(
      opacity: isCardDone ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: theme.barBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isExpanded ? theme.primaryColor : CupertinoColors.systemGrey.withOpacity(0.3),
            width: isExpanded ? 2.0 : 1.0,
          ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!isCardDone) {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Table ${widget.order.tableNumber}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: isExpanded && !isCardDone ? theme.primaryColor : theme.textTheme.textStyle.color,
                          decoration: isCardDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.order.timestamp.hour}:${widget.order.timestamp.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (!isCardDone)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: widget.onMarkAsDone,
                          child: const Icon(CupertinoIcons.check_mark_circled, color: CupertinoColors.systemGreen),
                        ),
                      Icon(
                        isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down,
                        color: isExpanded && !isCardDone ? theme.primaryColor : CupertinoColors.systemGrey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isExpanded && !isCardDone)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: widget.order.menuItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isDone = _doneItems.contains(index);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _toggleDone(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              isDone ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.circle,
                              color: isDone ? theme.primaryColor : CupertinoColors.inactiveGray,
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}