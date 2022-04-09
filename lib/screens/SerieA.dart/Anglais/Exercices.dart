import 'package:premiere/models/ListPdf.dart';
import 'package:premiere/widgets/card-horizontal.dart';
import 'package:premiere/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class ExercicesSScreen extends StatefulWidget {
  final String query;
  final bool firstSearch;

  const ExercicesSScreen({Key key, this.query, this.firstSearch})
      : super(key: key);
  @override
  _ExercicesSScreenState createState() => _ExercicesSScreenState();
}

class _ExercicesSScreenState extends State<ExercicesSScreen> {
  List<ListPdf> _listPdf;
  List<ListPdf> _filterListPdf;
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
      body: widget.firstSearch ? _buildListViewPdf() : _performSearch(),
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
              evaluation: item.evaluation,
              anAcad: 'Année Acad ' + item.anAcad,
              img: 'assets/img/imgpdf1.jpg',
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

  //Perform actual search
  Widget _performSearch() {
    _filterListPdf = new List<ListPdf>();
    for (int i = 0; i < _listPdf.length; i++) {
      var item = _listPdf[i];

      if (item.titre.toLowerCase().contains(widget.query.toLowerCase()) ||
          item.anAcad.toLowerCase().contains(widget.query.toLowerCase()) ||
          item.evaluation.toLowerCase().contains(widget.query.toLowerCase())) {
        _filterListPdf.add(item);
      }
    }
    return _createFilteredListView();
  }

  //Create the Filtered ListView
  ListView _createFilteredListView() {
    return ListView.builder(
        padding: const EdgeInsets.all(4.0),
        itemCount: _filterListPdf.length,
        itemBuilder: (context, index) {
          var item = _filterListPdf[index];

          return Container(
            alignment: Alignment.topRight,
            child: CardHorizontal(
              title: item.titre,
              chemin: item.chemin,
              evaluation: item.evaluation,
              anAcad: 'Année Acad ' + item.anAcad,
              img: 'assets/img/imgpdf1.jpg',
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
            'assets/pdf/serie A/Anglais/exercices/184477-la-reconnaissance-vocale-dans-son-application(1).pdf',
        evaluation: 'Évaluation 1',
        anAcad: '2017-2018',
      ),
      ListPdf(
        titre: 'Lycée Leclers',
        chemin:
            'assets/pdf/serie A/Anglais/exercices/186811-tout-sur-l-opensim.pdf',
        evaluation: 'Évaluation 1',
        anAcad: '2018-2019',
      ),
      ListPdf(
        titre: 'Lycée Leclers',
        chemin:
            'assets/pdf/serie A/Anglais/exercices/193225-decouverte-de-la-programmation-par-contraintes.pdf',
        evaluation: 'Évaluation 1',
        anAcad: '2015-2016',
      ),
      ListPdf(
        titre: 'Collège Adventiste Billingue Boma de Bertoua',
        chemin:
            'assets/pdf/serie A/Anglais/exercices/195423-un-compte-a-rebours-en-php.pdf',
        evaluation: 'Évaluation 4',
        anAcad: '2012-2013',
      ),
      ListPdf(
        titre: 'Collège Vogt',
        chemin:
            'assets/pdf/serie A/Anglais/exercices/200557-programmez-en-objective-c.pdf',
        evaluation: 'Évaluation 1',
        anAcad: '2011-2012',
      ),
      ListPdf(
        titre: 'Collège Vogt',
        chemin:
            'assets/pdf/serie A/Anglais/exercices/184477-la-reconnaissance-vocale-dans-son-application.pdf',
        evaluation: 'Évaluation 2',
        anAcad: '2011-2012',
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
