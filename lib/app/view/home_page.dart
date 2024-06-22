import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
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
  List<Categoria> categorias= [];
  String _selectedValue = '1';
  //late Categoria categoria;

  void navegarAPagina(BuildContext context, String ruta) {
    Navigator.pushNamed(context, ruta);
  }

  void getAllCategoria(){
    List<Categoria> tempCats = [
      Categoria(id:1, name: 'Bono', precio: 200),
      Categoria(id:2, name: 'Bono', precio: 400),
      Categoria(id:3, name: 'Bono', precio: 600),
      Categoria(id:4, name: 'Bono', precio: 1600),
      Categoria(id:5, name: 'Bono', precio: 4000),
      Categoria(id:6, name: 'Bono', precio: 8000),
    ];
    appDatabase.getAllCategorias().then((onValue) async  {
      setState(() {
        categorias = onValue;
      });
    }).catchError((onError){
      if (kDebugMode) {
        print(onError);
      }
    });
  }



  void _showToast(BuildContext context,String  msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
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

          backgroundColor: Theme
              .of(context)
              .colorScheme.primary,
          title: Text(widget.title),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selectedValue = value;
                });
                navegarAPagina(context, '/pagina1');
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: '1',
                  child: Text('Usuario'),
                ),
                const PopupMenuItem(
                  value: '2',
                  child: Text('Bono'),
                ),
                const PopupMenuItem(
                  value: '3',
                  child: Text('Cerrar Sesion'),
                ),
              ],
            )
          ],
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
            return GestureDetector(
                onTap: () {
                  _showToast(context, index.toString());
                },
            child:  Container(
              color: const Color.fromRGBO(234, 242, 255, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('B0NO',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                    )),
                  Text('\$${categorias[index].precio}')],
              ),
            )
            );
          },
        )
    );
  }
}
