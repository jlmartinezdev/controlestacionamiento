import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:control_estacionamiento/app/view/detail_entrada.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<Categoria> categorias = [];
  String _selectedValue = '1';

  //late Categoria categoria;

  void navegarAPagina(BuildContext context, String ruta) {
    Navigator.pushNamed(context, ruta).then((_) => {getAllCategoria()});
  }

  void getAllCategoria() {

    appDatabase.getAllCategorias().then((onValue) async {
      setState(() {
        categorias = onValue;
      });
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAllCategoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.title,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selectedValue = value;
                });
                if (_selectedValue == '1') {
                  navegarAPagina(context, '/pagina1');
                }
                if (_selectedValue == '2') {
                  navegarAPagina(context, '/categoria');
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: '1',
                  child: Row(
                    children: [
                      Icon(Icons.person,
                          color: Theme.of(context).colorScheme.primary),
                      const Text('Usuario'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: '2',
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Text('Categoria'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: '3',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const Text('Cerrar Sesion'),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        floatingActionButton:  FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          onPressed: (){
            navegarAPagina(context, '/entrada');
          },
          child: const Icon(Icons.list, color: Colors.white,),
        ),
        body:
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos columnas
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            final item = categorias[index];
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetailEntrada(categoria: item)));
                },
                child: Container(
                  color: const Color.fromRGBO(234, 242, 255, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.beenhere, color: Colors.grey,),
                      const Text('B0NO',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0)),
                      Text('\$${categorias[index].precio}')
                    ],
                  ),
                ));
          },
        ));
  }
}
