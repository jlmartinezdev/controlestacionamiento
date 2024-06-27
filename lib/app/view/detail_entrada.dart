import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/models/Entrada.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:control_estacionamiento/app/view/print_bono.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailEntrada extends StatefulWidget {
  final Categoria categoria;

  const DetailEntrada({super.key, required this.categoria});

  @override
  State<DetailEntrada> createState() => _DetailEntradaState();
}

class _DetailEntradaState extends State<DetailEntrada> {
  late String _time;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void getDateTime() {
    final DateTime now = DateTime.now();
    //final DateFormat formatter = DateFormat('yyyy');
    //final String formatted = formatter.format(now);
    final hora = DateFormat('Hm', 'en_US').format(now);
    setState(() {
      _time = hora.toString();
    });
  }

  void saveData() async {
    DatabaseHelper db = DatabaseHelper.instance;

    await db
        .insertEntrada(Entrada(
            id: 1,
            id_usuario: 1,
            monto: widget.categoria.precio,
            fechahora: "1"))
        .then((onValue) => {
              Navigator.pop(context),
              Navigator.push (context, MaterialPageRoute(builder: (context) =>(
                 PrintBonoView(
                    precio: widget.categoria.precio as double, id: onValue)
              )))
            });
  }

  @override
  void initState() {
    super.initState();
    getDateTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Registro de Entrada',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(0, 0),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      'BONO',
                      style: TextStyle(
                        fontSize: 22,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      '\$ ${widget.categoria.precio.toString()}',
                      style: const TextStyle(
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      _time,
                      style: const TextStyle(
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    saveData();
                  },
                  label: const Text('Confirmar e Imprimir'),
                  icon: const Icon(
                    Icons.print,
                    size: 22,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: const Color(0xffffffff),
                    padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 3,
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
