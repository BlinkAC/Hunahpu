import 'package:cursoflutter/classes/searchProducts.dart';
import 'package:cursoflutter/common%20widgets/side_menu.dart';
import 'package:cursoflutter/products/details_page.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListPage extends StatefulWidget {
  final AuthBase auth;

  const ListPage({Key? key, required this.auth}) : super(key: key);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin<ListPage> {
  String _scanBarcode = 'Unknown';
  var _widget;
  // CollectionReference ref1 =
  //     FirebaseFirestore.instance.collection('bebidasDeportivas');
  // CollectionReference ref2 = FirebaseFirestore.instance.collection('refrescos');
CollectionReference ref = FirebaseFirestore.instance.collection('bebidasDeportivas');
  getProds() async {
    var ref1 =
         FirebaseFirestore.instance.collection('bebidasDeportivas');
    return ref1;
  }

  navigateToDetails(DocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          productDetails: product,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _widget = ref.snapshots();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    DocumentSnapshot snapshot;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      snapshot = await FirebaseFirestore.instance
          .collection('Todos')
          .doc(barcodeScanRes)
          .get();
      navigateToDetails(snapshot);
      print(barcodeScanRes);
      print("NOMBRE DE DOCUMENTO LEIDO: " + snapshot["nombre"]);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    print("RECIBIDO: " + _scanBarcode);
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: SideMenu(auth: Auth()),
      appBar: AppBar(
        title: Text('Inicio'),
        actions: [IconButton(onPressed: (){showSearch(context: context, delegate:  SearchProduct());}, icon: Icon(Icons.search))],
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: StreamBuilder(
            stream: _widget,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return SingleChildScrollView(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    navigateToDetails(
                                        snapshot.data!.docs[index]);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 110,
                                      height: 200,
                                      margin:
                                          EdgeInsets.only(bottom: 5, right: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blueGrey,
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 7.0,
                                            ),
                                          ]),
                                          child: Column(
                                        children: [
                                          Image.network(
                                            snapshot.data!.docs[index]
                                                ["image"],
                                            width: 100,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          Text(snapshot.data!.docs[index]
                                              ["nombre"]),
                                          Text("Precio: " +
                                              snapshot
                                                  .data!.docs[index]["pHEB"]
                                                  .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(FontAwesomeIcons.barcode),
          onPressed: () {
            scanBarcodeNormal();
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
