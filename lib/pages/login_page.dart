import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'available_vehicles_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final response = await Supabase.instance.client.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response.error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AvailableVehiclesPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error!.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Bienvenido, Inicia Sesion')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder()
              ),
              obscureText: true,
              

              
            ),
            SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => _login(context),
              child: Text('Iniciar Sesion'),
            ),
          ],
        ),
      ),
    );
  }
}
