import 'package:cashier/boxes.dart';
import 'package:cashier/product.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Declare the global variable using late
late Box<Product> boxProducts;

void main() async {
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());

  // Open the box and assign it to the global variable
  boxProducts = await Hive.openBox<Product>('productsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hanya Kipas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hanya penggemar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controllers when no longer needed
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                          setState(() {
                            final name = nameController.text;
                            final category = (categoryController.text);
                            final price = int.tryParse(priceController.text);
                            final quantity =
                                int.tryParse(quantityController.text);

                            if (name.isNotEmpty &&
                                category.isNotEmpty &&
                                price != null &&
                                quantity != null) {
                              boxProducts.put(
                                'key_$name',
                                Product(
                                  name: name,
                                  category: category,
                                  price: price,
                                  quantity: quantity,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Onk seng error cik'),
                                ),
                              );
                            }
                          });
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ValueListenableBuilder(
                      valueListenable: boxProducts.listenable(),
                      builder: (context, Box<Product> box, _) {
                        if (box.isEmpty) {
                          return const Center(
                            child: Text('No data available'),
                          );
                        }

                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            final product = box.getAt(index);
                            if (product == null) {
                              return Container(); // Handle null person
                            }

                            return ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product : ${product.name}'),
                                  Text('Category : ${product.category}'),
                                  Text('Price : IDR${product.price}'),
                                  Text('Quantity : ${product.quantity}'),
                                ],
                              ),

                              leading: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  // Delete item
                                  box.deleteAt(index);
                                },
                              ),
                              // title:
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
