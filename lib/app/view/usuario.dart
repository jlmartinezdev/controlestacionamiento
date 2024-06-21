import 'package:control_estacionamiento/app/models/User.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
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
          label: const Text(" "),
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {});
          }),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final item = users[index];
          return ListTile(
            title: Text(item.name.toString(),
                style: const TextStyle(
                 fontSize: 24.0)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Lógica para editar el item
                    print('Editar $item');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Lógica para borrar el item
                    setState(() {
                     // items.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),

    );
  }
  
}

