import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:veins/src/core/models/menu_item.dart';

class EditMenuItemPage extends StatefulWidget {
  final MenuItem menuItem;

  const EditMenuItemPage({super.key, required this.menuItem});

  @override
  State<EditMenuItemPage> createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late PageController _pageController;
  late MenuItem _updatedMenuItem;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _updatedMenuItem = widget.menuItem;
    _descriptionController =
        TextEditingController(text: _updatedMenuItem.description);
    _priceController =
        TextEditingController(text: _updatedMenuItem.price.toString());
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedItem = MenuItem(
      name: _updatedMenuItem.name,
      photoUrls: _updatedMenuItem.photoUrls,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? _updatedMenuItem.price,
    );
    Navigator.of(context).pop(updatedItem);
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_updatedMenuItem.photoUrls.length, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? CupertinoTheme.of(context).primaryColor
                : CupertinoColors.systemGrey,
          ),
        );
      }),
    );
  }

  Widget _buildImageWidget(String path) {
    if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(_updatedMenuItem.name),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _updatedMenuItem.photoUrls.length,
                      itemBuilder: (context, index) {
                        return _buildImageWidget(
                            _updatedMenuItem.photoUrls[index]);
                      },
                    ),
                  ),
                  if (_updatedMenuItem.photoUrls.length > 1)
                    _buildPageIndicator(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: theme.textTheme.navTitleTextStyle
                              .copyWith(color: CupertinoColors.systemGrey),
                        ),
                        const SizedBox(height: 8),
                        CupertinoTextField(
                          controller: _descriptionController,
                          placeholder: 'Enter item description',
                          maxLines: 4,
                          textInputAction: TextInputAction.next,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.barBackgroundColor.withAlpha(128),
                            border: Border.all(
                              color: theme.barBackgroundColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Price',
                            style: theme.textTheme.navTitleTextStyle
                                .copyWith(color: CupertinoColors.systemGrey),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              child: CupertinoTextField(
                                controller: _priceController,
                                placeholder: 'Enter item price',
                                keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true),
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.center,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color:
                                      theme.barBackgroundColor.withAlpha(128),
                                  border: Border.all(
                                    color: theme.barBackgroundColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
