import 'package:control_estacionamiento/app/models/User.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:control_estacionamiento/app/view/cm_usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.title});

  final String title;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<User> users= [];
  final int test = 1;

  getAllUser() {
    appDatabase.getAllUsers().then((onValue) async  {
      setState(() {
        users = onValue;
      });
    }).catchError((onError){
      if (kDebugMode) {
        print(onError);
      }
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllUser();
  }
  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        backgroundColor: Theme
        .of(context)
        .colorScheme
        .inversePrimary,
    title: Text(widget.title),
    ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Nuevo Usuario"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  CmUsuarioView(
                    title: 'Nuevo Usuario',
                    idLength:  users.length + 1,
                    isNew: true,
                    user: User(id_usuario: 0,name: '',dni:'',password: '',email: '',rol: 1),
                  )),
            ).then((_)=>{
              getAllUser()
            });
          }),
      body: ListView.separated(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final item = users[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white70,
              child: Icon(Icons.person,color: Colors.grey,),
            ),
            title: Text(item.name.toString(),
                style: const TextStyle(
                 fontSize: 20.0)),
            subtitle: Text(item.email.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  CmUsuarioView(
                            title: 'Editar Usuario',
                            idLength: int.parse(item.id_usuario.toString()),
                            isNew: false,
                            user: item,
                          )),
                    ).then((_)=>{
                      getAllUser()
                    });

                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Desea eliminar usuario?'),
                        content: const Text('Se eliminara permanentemente de la base de datos'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );

                    if (result == null || !result) {
                      return;
                    }
                    appDatabase.deleteUser(int.parse(item.id_usuario.toString())).then((success)=>{
                      getAllUser()
                    });

                  },
                ),
              ],
            ),

          );
        },
        separatorBuilder: (context, index) { // <-- SEE HERE
          return const Divider();
        },
      ),

    );

  }

  
}

