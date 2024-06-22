
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/User.dart';
import '../service/database_helper.dart';


class CmUsuarioView extends StatefulWidget {
  final String title;
  final int idLength;
  final bool isNew;
  final User user;


  const CmUsuarioView({super.key, required this.title, required this.idLength, required this.isNew, required this.user});

  @override
  State<CmUsuarioView> createState() => _CmUsuarioState();
}

class _CmUsuarioState extends State<CmUsuarioView> {
  late String _username, _password, _email, _dni;
  late int _rol,_id;


  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<User> users = [];
  late User user;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey =  GlobalKey<ScaffoldState>();
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "1", child: Text("Administrador Gral")),
      const DropdownMenuItem(value: "2", child: Text("Administrador")),
      const DropdownMenuItem(value: "3", child: Text("Operador")),

    ];
    return menuItems;
  }
  @override
  void initState() {
    super.initState();
    getMaxId();
  }
  void getMaxId(){
    appDatabase.getMaxUser().then((onValue) async=>{
      setState(() {
        _id= onValue + 1;
      })
    });
  }
  void _showSnackBar(String text, int type) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(text),
      backgroundColor: type==1 ?const Color.fromARGB(255, 4, 160, 74) : const Color.fromARGB(255,255,0,0),
    ));

  }
  void saveData(User user) async {
    //print("HI");
    DatabaseHelper db = DatabaseHelper.instance;
    if(widget.isNew){
      await db.insertMetodo2(user).
      then((user) {
        _showSnackBar('OK', 1);
        Navigator.pop(context, { getAllUser()});
      }).catchError((onError) {
        _showSnackBar(onError, 2);
      });
    }else{
      await db.updateUser(user).
      then((user) {
        _showSnackBar('OK', 1);
        Navigator.pop(context, { setState(() {

        })});
      }).catchError((onError) {
        _showSnackBar(onError, 2);
      });
    }


  }
  void _submit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      setState(() {
        form.save();
        saveData(User(id_usuario: widget.isNew ? _id :  widget.idLength ,name: _username, dni: _dni, password: _password, email: _email, rol: _rol));
     //   _presenter.doLogin(_username, _password);
      });
    }
  }
  getAllUser() async {
    var userst = await appDatabase.users();
    setState(() {
      users = userst;
    });
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white),),

      ),
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
                  child: TextFormField(
                    onSaved: (val) => _username = val!,
                    initialValue: widget.user.name,
                    decoration: const InputDecoration(
                      labelText: 'Nombre y Apellido',
                      hintText: 'Nombre y Apellido',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onSaved: (val) => _dni = val!,
                    initialValue: widget.user.dni,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'DNI',
                      hintText: 'DNI',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su dni';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onSaved: (val) => _email = val!,
                    initialValue: widget.user.email,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electronico',
                      hintText: 'Correo Electronico',
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
                Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child:DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Rol usuario",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null ? "Seleccione un opcion" : null,
                    value: widget.isNew ? dropdownItems.first.value: dropdownItems[int.parse(widget.user.rol.toString())].value,
                    onSaved: (val) => _rol= int.parse(val.toString()),
                    onChanged: (newValue) {
                      setState(() {
                        _rol= int.parse(newValue.toString());
                      });
                    },

                    items : dropdownItems.map((item) {
                      return  DropdownMenuItem<String>(
                        value: item.value,
                        child: item.child, //FAIL
                      );
                    }).toList() )),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onSaved: (val) => _password = val!,
                    initialValue: widget.user.password,
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
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(56),
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          foregroundColor: const Color(0xffffffff)),
                      child: const Text('Guardar Datos',
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
