import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursoflutter/classes/favoritesList.dart';
import 'package:cursoflutter/classes/productModel.dart';
import 'package:cursoflutter/common%20widgets/side_menu.dart';
import 'package:cursoflutter/products/details_page.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteProducts extends StatelessWidget {
  const FavoriteProducts({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  retrieveFavList() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    if (await File("${directory!.path}/UserFavs.json").exists()) {
      final jsondata =
          await File("${directory.path}/UserFavs.json").readAsString();
      final list = json.decode(jsondata) as List<dynamic>;
      return list.map((e) => ProductList.fromJson(e)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    FavoriteList prodFav = new FavoriteList();
    navigateToDetails(String codigo) async {
      DocumentSnapshot product = await FirebaseFirestore.instance
          .collection('Todos')
          .doc('$codigo')
          .get();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsPage(
            productDetails: product,
          ),
        ),
      );
    }

    return Scaffold(
      drawer: SideMenu(auth: auth),
      appBar: AppBar(
        title: Text("Favoritos seleccionados"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder(
        future: retrieveFavList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            var items = snapshot.data as List<ProductList>;
            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: GestureDetector(
                          onTap: () {
                            navigateToDetails(items[index].codigo.toString());
                          },
                          child: Row(
                            children: [
                              Image.network(items[index].image.toString(),
                                  width: 50, height: 50),
                              SizedBox(
                                width: 15,
                              ),
                              Text(items[index].nombre.toString(),
                                  style: TextStyle(fontSize: 18)),
                              IconButton(
                                  icon: Icon(Icons.delete_rounded,
                                      color: Colors.grey),
                                  padding: EdgeInsets.only(left: 40),
                                  onPressed: () {
                                    prodFav.deleteUserFavs(
                                        items[index].codigo.toString());
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Aviso'),
                                          content: Text(
                                              'Producto eliminado satisfactoriamente de su lista de favoritos'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('Entendido')),
                                          ],
                                        );
                                      });
                                  })
                            ],
                          ),
                        ),
                      ));
                });
          } else {
            return Center(
              child: Container(
                width: 300,
                height: 500,
                child: Column(
                  children: [
                    Text('Parece que aun no has agregado productos a tu lista',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/shopping-list.png',
                      width: 150,
                      height: 150,
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
