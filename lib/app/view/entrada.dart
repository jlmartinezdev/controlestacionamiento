import 'package:control_estacionamiento/app/models/Entrada.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntradaView extends StatefulWidget {
  const EntradaView({super.key});

  @override
  State<EntradaView> createState() => _EntradaViewState();
}

class _EntradaViewState extends State<EntradaView> {

  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<Entrada> entradas = [];

  void getAllCategoria() async {
    await appDatabase.getAllEntrada().then((onValue) {
      setState(() {
        entradas = onValue;
      });
    }).catchError((onError) {
      if (kDebugMode) {
        print(onError);
      }
    });
  }
  String getFecha(String f){
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(f) * 1000);
    final DateFormat formatter = DateFormat('HH:mm dd/MM/yyyy');
    return formatter.format(date);
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
        title: const Text("Entradas", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView.separated(
        itemCount: entradas.length,
        itemBuilder: (context, index) {
          final item = entradas[index];
          return ListTile(
            leading: Text(item.id.toString()),
            title: Text('Bono \$${item.monto}',
                style: const TextStyle(
                    fontSize: 20.0)),
            subtitle: Text(getFecha(item.fechahora.toString())),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey,),
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: const Text('Desea eliminar categoria?'),
                            content: const Text(
                                'Se eliminara permanentemente de la base de datos'),
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
                    appDatabase.deleteEntrada(int.parse(item.id.toString()))
                        .then((success) =>
                    {
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
