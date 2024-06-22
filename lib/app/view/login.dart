import 'package:control_estacionamiento/app/view/home_page.dart';
import 'package:flutter/material.dart';
import '../models/User.dart';
import '../service/database_helper.dart';
import 'login_presenter.dart';

class LoginView extends StatefulWidget {
  final String title;


  const LoginView({Key? key, required this.title}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginState();
}

class _LoginState extends State<LoginView> implements LoginPageContract {
  late LoginPagePresenter _presenter;
  late String _username, _password;
  _LoginState() {
    _presenter = new LoginPagePresenter(this);
  }
  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<User> users = [];
  late User user;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  void _showSnackBar(String text, int type) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(text),
      backgroundColor: type==1 ?const Color.fromARGB(255, 4, 160, 74) : const Color.fromARGB(255,255,0,0),
    ));

  }
  void _submit() {
    final form = _formKey.currentState;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => const MyHomePage(
          title: 'Inicio',
        )), (Route<dynamic> route) => false);


   /* if (form!.validate()) {
      setState(() {
        form.save();
        _presenter.doLogin(_username, _password);
      });
    }*/
  }
  getAllUser() async {
    var userst = await appDatabase.users();
    setState(() {
      users = userst;
    });
  }

  @override
  void initState() {
    //appDatabase.deleteAllCategoria();
    /*var model = User(
        id_usuario: 1,
        name: 'Admin',
        dni: '35',
        password: '12345',
        email: 'admin@admin',
        rol: 1
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
    //getAllUser();
    super.initState();
  }

  @override
  dispose() {
    // Close the database when no longer needed
    //appDatabase.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Iniciar sesión'),
      ),*/
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Image.asset('assets/empresa.png', height: 268),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text('Iniciar Sesión',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: emailController,
                    onSaved: (val) => _username = val!,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: passwordController,
                    onSaved: (val) => _password = val!,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: 'Contraseña', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese contraseña';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _submit();
                        /*if (_formKey.currentState!.validate()) {
                          if (emailController.text == "arun@gogosoon.com" &&
                              passwordController.text == "qazxswedcvfr") {
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
                                  content: Text('Invalid Credentials')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Completa los datos!')),
                          );
                        }*/
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

  @override
  void onLoginError(String error) {
    _showSnackBar(error,2);
    setState(() {
    });
  }

  @override
  void onLoginSuccess(User user) {
    _showSnackBar("Bienvenido: ${user.name}",1);
    setState(() {
    });
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => const MyHomePage(
          title: 'Categoria',
        )), (Route<dynamic> route) => false);

  }
}
