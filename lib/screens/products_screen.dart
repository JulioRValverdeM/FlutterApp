import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsScreen extends StatefulWidget {

  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() =>
      _ProductsScreenState();
}

class _ProductsScreenState
    extends State<ProductsScreen> {

  String token = '';

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {

    final prefs =
        await SharedPreferences.getInstance();

    final savedToken =
        prefs.getString('token') ?? '';

    setState(() {
      token = savedToken;
    });

    print('TOKEN: $savedToken');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(token),
      ),
    );
  }
}