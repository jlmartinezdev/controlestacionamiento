import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:control_estacionamiento/app/view/cm_categoria.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CategoriaView extends StatefulWidget {
  const CategoriaView({super.key});

  @override
  State<CategoriaView> createState() => _CategoriaViewState();
}

class _CategoriaViewState extends State<CategoriaView> {
  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<Categoria> categorias= [];

   void getAllCategoria() async{
     await appDatabase.getAllCategorias().then((onValue)   {
       setState(() {
         categorias = onValue;
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
    getAllCategoria();
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
            .colorScheme
            .primary,
        title: const Text("Categoria Bono", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text("Nueva Categoria"),
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  CmCategoriaView(
                    title: 'Nueva Categoria',
                    isNew: true,
                    categoria: Categoria(id: categorias.length,name: '',precio: 0),
                  )),
            ).then((_)=>{
              getAllCategoria()
            });
          }),
      body: ListView.separated(
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final item = categorias[index];
          return ListTile(
            leading:  CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.check ,color: Colors.white,),
            ),
            title: Text(item.name.toString(),
                style: const TextStyle(
                    fontSize: 20.0)),
            subtitle: Text(item.precio.toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  CmCategoriaView(
                            title: 'Editar Categoria',
                            isNew: false,
                            categoria: item,
                          )),
                    ).then((_)=>{
                      getAllCategoria()
                    });

                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey,),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Desea eliminar categoria?'),
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
                    appDatabase.deleteCategoria(int.parse(item.id.toString())).then((success)=>{
                      getAllCategoria()
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
