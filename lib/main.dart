// main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'input_modal.dart';
import 'product.dart';
import 'boxes.dart';

late Box<Product> boxProducts;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ProductAdapter());
  boxProducts = await Hive.openBox<Product>('productsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Box<Product> boxProducts;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    boxProducts = Hive.box<Product>('productsBox');
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _showInputModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return InputModal(
          nameController: nameController,
          categoryController: categoryController,
          priceController: priceController,
          quantityController: quantityController,
          onAdd: (String name, String category, int price, int quantity) {
            setState(() {
              boxProducts.put(
                'key_$name',
                Product(
                  name: name,
                  category: category,
                  price: price,
                  quantity: quantity,
                ),
              );
            });
            Navigator.pop(context); // Close the modal after adding
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(15, 12, 15, 1),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Items : ${boxProducts.length}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    Text(
                      'Total Income : Belum jualan Cik nguawur',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _showInputModal(context),
                    child: Text('Add Product'),
                  ),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                  ))
                ],
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
                              return Container();
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
                                  box.deleteAt(index);
                                },
                              ),
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
