import 'dart:io';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart'
    show LoremText, PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintBonoView extends StatefulWidget {
  final double precio;
  final int id;
  const PrintBonoView({super.key, required this.precio, required this.id});

  @override
  PrintBonoState createState() {
    return PrintBonoState();
  }

}

class PrintBonoState extends State<PrintBonoView>
    with SingleTickerProviderStateMixin {


  late String _diasemana;
  late String _hora;
  late String _diames;
  final List<String> dias= ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'];
  void getDateTime(){
    final DateTime now = DateTime.now();
    //final DateFormat formatter = DateFormat('yyyy');
    //final String formatted = formatter.format(now);
    final hora = DateFormat('Hm', 'en_US').format(now);
    final mesdia= DateFormat('dd/MM').format(now);
    setState(() {
      _diasemana= dias[now.weekday];
      _hora= hora.toString();
      _diames= mesdia;

    });
  }

  @override
  void initState() {
    super.initState();
    getDateTime();
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Container(
              height: 210,
              width: 210,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(5),
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 3,
                ),
              ),
              child: pw.Column(
                //mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Padding(
                    padding:
                        const pw.EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: pw.Text(
                      '$_diasemana $_diames',
                      style: pw.TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding:
                        const pw.EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
                    child: pw.Text(
                      'Bono \$${widget.precio}',
                      style: pw.TextStyle(
                        fontSize: 28,
                        letterSpacing: 0,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding:
                        const pw.EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: pw.Text(
                      'N°: ${widget.id}',
                      style: const pw.TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  pw.Text(
                    'Hora: $_hora',
                    style: const pw.TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _saveAsFile(
    BuildContext context,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    final bytes = await build(pageFormat);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(

        content: Text('Imprimir documento OK'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compartir documento OK'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: const Text('Imprimir Bono', style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PdfPreview(
       // maxPageWidth: 700,
        canChangePageFormat : false,
        canChangeOrientation : false,
        initialPageFormat: PdfPageFormat.roll80,
        build: (format) => _generatePdf(format, "Test"),
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
    );
  }
}
