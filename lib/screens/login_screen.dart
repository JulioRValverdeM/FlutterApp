import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'products_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool loading = false;

  Future<void> doLogin() async {

    setState(() {
      loading = true;
    });

    final ok =
    await AuthService().login(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      loading = false;
    });

    if (!mounted) return;

    if (ok) {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const ProductsScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text('Credenciales inválidas'),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('EcoHome'),
      ),
      body: Padding(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller:
              emailController,
              decoration:
              const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
              passwordController,
              obscureText: true,
              decoration:
              const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
              loading ? null : doLogin,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text(
                  'Ingresar'),
            )
          ],
        ),
      ),
    );
  }
}