// main.dart

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'input_modal.dart';
import 'product.dart';
// import 'boxes.dart';

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
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevents closing the modal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          content: InputModal(
            nameController: TextEditingController(),
            categoryController: TextEditingController(),
            priceController: TextEditingController(),
            quantityController: TextEditingController(),
            onAdd: (name, category, price, quantity) {
              // Handle the add action
              Navigator.of(context).pop(); // Close the modal
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(15, 12, 15, 1),
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 70,
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.blue),
                      color: const Color.fromRGBO(252, 203, 102, 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        boxProducts.length == 0
                            ? 'Total Items : Belum ada'
                            : 'Total Item : ${boxProducts.length}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 15),
                      ),
                      const Text(
                        'Total Income : Belum jualan',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 15),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
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
                      onPressed: () => _showInputModal(context),
                      child: const Text('Add Product'),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                        child: SizedBox(
                      height: 43,
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search_rounded),
                          ),
                          suffixIconColor:
                              const Color.fromRGBO(255, 83, 137, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 83, 137, 1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 83, 137, 1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(255, 83, 137, 1)),
                          ),
                          hintText: 'Cari Product',
                          hintStyle: const TextStyle(fontSize: 15),
                          contentPadding: const EdgeInsets.only(
                            left: 15,
                            bottom: 3,
                            top: 3,
                            right: 5,
                          ),
                        ),
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
      ),
    );
  }
}
