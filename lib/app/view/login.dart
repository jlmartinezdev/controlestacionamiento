import 'package:control_estacionamiento/app/view/home_page.dart';
import 'package:flutter/material.dart';

import '../models/User.dart';
import '../service/database_helper.dart';

class LoginView extends StatefulWidget {
  final String title;

  const LoginView({Key? key, required this.title}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<User> users = [];
  late User user;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  getAllUser() async {
    var userst = await appDatabase.users();
    setState(() {
      users = userst;
    });
  }

  @override
  void initState() {
    /*var model = User(
        id_usuario: 1,
        name: 'Admin',
        dni: '35',
        password: '12345',
        email: 'admin@admin'
    );
      appDatabase.deleteUser(4);
      appDatabase.deleteUser(5);
      appDatabase.insertMetodo2(model).then((respond) async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Usuario Agregado correctamente."),
          backgroundColor: Color.fromARGB(255, 4, 160, 74),
        ));
       /* Navigator.pop(context, {
          'reload': true,
        });*/
      }).catchError((error) {
        if (kDebugMode) {
          print(error);
        }
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Note failed to save."),
          backgroundColor: Color.fromARGB(255, 235, 108, 108),
        ));
      });
*/
    getAllUser();
    super.initState();
  }

  @override
  dispose() {
    // Close the database when no longer needed
    appDatabase.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Iniciar sesión'),
      ),*/
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  child: Image.asset('assets/empresa.png', height: 268),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('Iniciar Sesión',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'Nombre Usuario',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese contraseña';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                      title: 'Categoria',
                                    )),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Completa los datos!')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: const Color(0xffffffff)),
                      child: const Text('Iniciar sesión',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
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
