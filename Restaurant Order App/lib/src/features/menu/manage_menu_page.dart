import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/models/menu_item.dart';
import 'package:veins/src/features/menu/add_menu_item_page.dart';
import 'package:veins/src/features/menu/edit_menu_item_page.dart';

class ManageMenuPage extends StatefulWidget {
  final List<MenuItem> menuItems;

  const ManageMenuPage({super.key, required this.menuItems});

  @override
  State<ManageMenuPage> createState() => _ManageMenuPageState();
}

class _ManageMenuPageState extends State<ManageMenuPage> {
  late List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = widget.menuItems;
  }

  void _navigateToAddPage() async {
    final newItem = await Navigator.of(context).push<MenuItem>(
      CupertinoPageRoute(
        builder: (context) => const AddMenuItemPage(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _menuItems.add(newItem);
      });
    }
  }

  void _navigateToEditPage(MenuItem menuItem) async {
    final updatedMenuItem = await Navigator.of(context).push<MenuItem>(
      CupertinoPageRoute(
        builder: (context) => EditMenuItemPage(menuItem: menuItem),
      ),
    );

    if (updatedMenuItem != null) {
      setState(() {
        final index =
            _menuItems.indexWhere((item) => item.name == updatedMenuItem.name);
        if (index != -1) {
          _menuItems[index] = updatedMenuItem;
        }
      });
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(MenuItem menuItem) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete ${menuItem.name}?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Manage Menu'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CupertinoListSection.insetGrouped(
                header: const Text('Menu Items'),
                children: _menuItems.map((item) {
                  return Dismissible(
                    key: Key(item.name),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) =>
                        _showDeleteConfirmationDialog(item),
                    onDismissed: (direction) {
                      setState(() {
                        _menuItems.remove(item);
                      });
                    },
                    background: Container(
                      color: CupertinoColors.destructiveRed,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        CupertinoIcons.delete,
                        color: CupertinoColors.white,
                      ),
                    ),
                    child: CupertinoListTile(
                      title: Text(item.name),
                      subtitle: Text(item.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('\$${item.price.toStringAsFixed(2)}'),
                          const SizedBox(width: 16),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final bool? confirmed =
                                  await _showDeleteConfirmationDialog(item);
                              if (confirmed == true) {
                                setState(() {
                                  _menuItems.remove(item);
                                });
                              }
                            },
                            child: const Icon(CupertinoIcons.delete,
                                color: CupertinoColors.destructiveRed),
                          ),
                        ],
                      ),
                      onTap: () => _navigateToEditPage(item),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: _navigateToAddPage,
                child: const Text('Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
