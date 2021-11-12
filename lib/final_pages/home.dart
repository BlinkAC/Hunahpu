import 'package:cursoflutter/final_pages/departments_page.dart';
import 'package:cursoflutter/final_pages/favorite_products_page.dart';
import 'package:cursoflutter/final_pages/sales_page.dart';
import 'package:cursoflutter/products/list_view_of_prod.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  // HomePage({Key? key, required this.auth}) : super(key: key);
  // final AuthBase auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _scanBarcode = 'Unknown';
  var _currentIndex;
  late PageController _pageController;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pages = [
      ListPage(auth: Auth()),
      Deparments(auth: Auth()),
      FavoriteProducts(auth: Auth()),
      SalesPage(auth: Auth())
    ];

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey.shade400,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white12,
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
          items: [
            //Necesita por lo menos 2
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.home), label: "Inicio"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.shoppingBasket),
                label: "Departamentos"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.heart), label: "Favoritos"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.percentage), label: "Rebajas"),
          ]),
    );
  }
}

//body: _pages[_currentIndex]



