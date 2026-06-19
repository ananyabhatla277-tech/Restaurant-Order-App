import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:veins/src/core/models/menu_item.dart';

class AddMenuItemPage extends StatefulWidget {
  const AddMenuItemPage({super.key});

  @override
  State<AddMenuItemPage> createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagePicker = ImagePicker();
  final List<XFile> _imageFiles = [];

  Future<void> _pickImage() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    setState(() {
      _imageFiles.addAll(pickedFiles);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

  void _saveItem() {
    final name = _nameController.text;
    final description = _descriptionController.text;
    final price = _priceController.text;

    if (name.isEmpty || description.isEmpty || price.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Incomplete Fields'),
          content: const Text('Please fill out all fields before saving.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    if (double.tryParse(price) == null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Invalid Price'),
          content: const Text('Please enter a valid number for the price.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final newItem = MenuItem(
      name: name,
      description: description,
      price: double.parse(price),
      photoUrls: _imageFiles.map((file) => file.path).toList(),
    );
    Navigator.of(context).pop(newItem);
  }

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoPageScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add Menu Item'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _nameController,
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
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    textAlignVertical: TextAlignVertical.top,
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
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CupertinoTextField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
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
                  const Text(
                    'Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _imageFiles.length) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CupertinoButton(
                              onPressed: _pickImage,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color:
                                      theme.barBackgroundColor.withAlpha(128),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  CupertinoIcons.add,
                                  size: 40,
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(_imageFiles[index].path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: CupertinoColors.black,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.xmark,
                                      color: CupertinoColors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoButton.filled(
                onPressed: _saveItem,
                child: const Text('Save Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
