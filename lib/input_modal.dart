// input_modal.dart

import 'package:flutter/material.dart';

class InputModal extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController categoryController;
  final TextEditingController priceController;
  final TextEditingController quantityController;
  final Function(String name, String category, int price, int quantity) onAdd;

  const InputModal({
    Key? key,
    required this.nameController,
    required this.categoryController,
    required this.priceController,
    required this.quantityController,
    required this.onAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Product Name',
            ),
          ),
          const SizedBox(height: 10.0),
          TextField(
            controller: categoryController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Category',
            ),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Price',
            ),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Quantity',
            ),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              final name = nameController.text;
              final category = categoryController.text;
              final price = int.tryParse(priceController.text);
              final quantity = int.tryParse(quantityController.text);

              if (name.isNotEmpty &&
                  category.isNotEmpty &&
                  price != null &&
                  quantity != null) {
                onAdd(name, category, price, quantity);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields correctly.'),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
