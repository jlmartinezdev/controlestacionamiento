import 'package:control_estacionamiento/app/view/home_page.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Iniciar sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 40.0),
        child: Column(
          children: [
            const Text('Bienvendio',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0
            )),
            const SizedBox(height: 24,),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Usuario',
                hintText: 'Nombre Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Prueba',)),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: const Color(0xffffffff)
              ),
              child: const Text('Iniciar sesión',style : TextStyle(
              fontWeight: FontWeight.bold,
            )),
            ),
          ],
        ),
      ),
    );
  }
}