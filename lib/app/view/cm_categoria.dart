import 'package:control_estacionamiento/app/models/Categoria.dart';
import 'package:control_estacionamiento/app/service/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CmCategoriaView extends StatefulWidget {
  final bool isNew;
  final String title;
  final Categoria categoria;
  const CmCategoriaView({super.key, required this.isNew, required this.title, required this.categoria});

  @override
  State<CmCategoriaView> createState() => _CmCategoriaViewState();
}

class _CmCategoriaViewState extends State<CmCategoriaView> {
  late String _name;
  late int _id;
  late double _precio;

  DatabaseHelper appDatabase = DatabaseHelper.instance;
  List<Categoria> categorias = [];
  late Categoria categoria;
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getMaxId();
  }

  void _showSnackBar(String text, int type) {
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(text),
      backgroundColor: type==1 ?const Color.fromARGB(255, 4, 160, 74) : const Color.fromARGB(255,255,0,0),
    ));

  }
  void getMaxId(){
    appDatabase.getMaxCategoria().then((onValue) async=>{
      setState(() {
        _id= onValue + 1;
      })
    });
  }
  void saveData(Categoria cat) async {
    //print("HI");
    DatabaseHelper db = DatabaseHelper.instance;
    if(widget.isNew){
      await db.insertCategoria(cat).
      then((user) {
        Navigator.pop(context);
      }).catchError((onError) {

      });
    }else{
      await db.updateCategoria(cat).
      then((user) {
        Navigator.pop(context);
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
        saveData(Categoria(id: widget.isNew ? _id : widget.categoria.id  ,name: _name, precio: _precio));
        //   _presenter.doLogin(_username, _password);
      });
    }
  }
  getAllCategoria() async {
    var userst = await appDatabase.getAllCategorias();
    setState(() {
      categorias = userst;
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
        automaticallyImplyLeading: false,
        leading: IconButton(
          iconSize: 60,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color:  Colors.white,
            size: 30,
          ),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
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
                    onSaved: (val) => _name = val!,
                    initialValue: widget.categoria.name,
                    decoration: const InputDecoration(
                      labelText: 'Descripcion Categoria',
                      hintText: 'Descripcion',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese una descripcion';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    onSaved: (val) => _precio = double.parse(val!),
                    initialValue: widget.categoria.precio.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      hintText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese precio';
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
