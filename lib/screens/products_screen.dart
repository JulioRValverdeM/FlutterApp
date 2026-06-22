import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user_stats.dart';

import '../services/product_service.dart';
import '../services/user_service.dart';

import 'chat_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> productsFuture;

  UserStats? stats;

  @override
  void initState() {
    super.initState();

    productsFuture = ProductService().getProducts();

    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final result = await UserService().getStats();

      setState(() {
        stats = result;
      });
    } catch (e) {
      debugPrint('Error cargando estadísticas: $e');
    }
  }

  Future<void> refreshData() async {
    setState(() {
      productsFuture = ProductService().getProducts();
    });

    await loadStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          stats == null
              ? 'Catálogo'
              : '${stats!.username} (${stats!.productsCount})',
        ),
      ),

      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                ),
              );
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Text(
                      'No hay productos disponibles',
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        product.id.toString(),
                      ),
                    ),
                    title: Text(
                      product.name,
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ${product.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'Creado por: ${product.username}',
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ChatScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}