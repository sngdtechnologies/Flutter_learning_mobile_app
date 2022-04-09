import 'package:premiere/models/ListPdf.dart';
import 'package:premiere/widgets/card-horizontal.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class CoursSScreen extends StatefulWidget {
  @override
  _CoursSScreenState createState() => _CoursSScreenState();
}

class _CoursSScreenState extends State<CoursSScreen> {
  List<ListPdf> _listPdf;
  @override
  void initState() {
    super.initState();
    _listpdf();
  }

  Future<String> prepareTestPdf(_documentPath) async {
    final ByteData bytes =
        await DefaultAssetBundle.of(context).load(_documentPath);
    final Uint8List list = bytes.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final tempDocumentPath = '${tempDir.path}/$_documentPath';

    final file = await File(tempDocumentPath).create(recursive: true);
    file.writeAsBytesSync(list);
    return tempDocumentPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ArgonDrawer(currentPage: "Series"),
      body: _buildListViewPdf(),
    );
  }

  ListView _buildListViewPdf() {
    return ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: _listPdf.length,
        itemBuilder: (context, index) {
          var item = _listPdf[index];
          return Container(
            alignment: Alignment.topRight,
            child: CardHorizontal(
              title: item.titre,
              chemin: item.chemin,
              img: 'assets/img/imgpdf1.jpg',
              anAcad: item.anAcad,
              tap: () {
                prepareTestPdf(item.chemin).then((path1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FullPdfViewerScreen(path1, item.titre)),
                  );
                });
              },
            ),
          );
        });
  }

  void _listpdf() {
    var list = <ListPdf>[
      ListPdf(
        titre: 'Collège Billingue Terrenstra de Bertoua',
        chemin:
            'assets/pdf/serie TI/Anglais/cours/134798-apprenez-a-programmer-en-vb-net.pdf',
        anAcad: '2015-2016',
      ),
      ListPdf(
        titre: 'Lycée Leclers',
        chemin:
            'assets/pdf/serie TI/Anglais/cours/145147-comment-faire-une-page-ayant-la-meme-hauteur-que-le-navigateur.pdf',
        anAcad: '2009-2010',
      ),
      ListPdf(
        titre: 'Lycée Leclers',
        chemin:
            'assets/pdf/serie TI/Anglais/cours/0023-formation-securite-informatique-pirate-pc.pdf',
        anAcad: '2010-2011',
      ),
      ListPdf(
        titre: 'Collège Vogt',
        chemin:
            'assets/pdf/serie TI/Anglais/cours/147180-programmez-en-oriente-objet-en-php.pdf',
        anAcad: '2013-2014',
      ),
      ListPdf(
        titre: 'Collège Vogt',
        chemin:
            'assets/pdf/serie TI/Anglais/cours/0023-formation-securite-informatique-pirate-pc.pdf',
        anAcad: '2013-2014',
      ),
    ];

    setState(() {
      _listPdf = list;
    });
  }
}

class FullPdfViewerScreen extends StatelessWidget {
  final String pdfPath;
  final String namePdf;

  FullPdfViewerScreen(this.pdfPath, this.namePdf);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text(namePdf),
        ),
        path: pdfPath);
  }
}
