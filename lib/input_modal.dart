import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    return AnimatedContainer(
      // transform: ,
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 5, right: 5, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Product',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20.0),
            _buildTextField(
              controller: nameController,
              hintText: 'Product Name',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10.0),
            _buildTextField(
              controller: categoryController,
              hintText: 'Category',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.5),
                    child: _buildTextField(
                      controller: priceController,
                      hintText: 'Price',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.5),
                    child: _buildTextField(
                      controller: quantityController,
                      hintText: 'Quantity',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.white),
                    foregroundColor: const MaterialStatePropertyAll(
                        Color.fromRGBO(255, 83, 137, 1)),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll<Color>(
                        Color.fromRGBO(255, 83, 137, 1)),
                    foregroundColor:
                        const MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 20.0,
          ),
        ),
      ),
    );
  }
}
