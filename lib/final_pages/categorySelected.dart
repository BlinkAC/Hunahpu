import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursoflutter/classes/favoritesList.dart';
import 'package:flutter/material.dart';

class SelectedCategory extends StatefulWidget {
  SelectedCategory(
      {required this.department,
      required this.subDepartment,
      required this.category});
  final String department;
  final String subDepartment;
  final String category;

  @override
  _SelectedCategoryState createState() => _SelectedCategoryState();
}

class _SelectedCategoryState extends State<SelectedCategory> {
  final FavoriteList favList = new FavoriteList();
  bool liked = false;

  getProds() {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('Departamentos')
        .doc(widget.department)
        .collection(widget.subDepartment);
    return ref.snapshots();
  }

  pressed() {
    setState(() {
      liked = !liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departamento ' + widget.department),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: getProds(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.count(
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(10),
              children: List.generate(
                snapshot.data!.docs.length,
                (index) {
                  //print(userId + 'USER ID');
                  String codigo = snapshot.data!.docs[index].id;
                  String nombreProd = snapshot.data!.docs[index]["nombre"];
                  String image = snapshot.data!.docs[index]["image"];

                  return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 7.0,
                          ),
                        ]),
                    child: Column(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Image.network(
                                image,
                                width: 180,
                                height: 180,
                              ),
                              IconButton(
                                padding: EdgeInsets.only(right: 120),
                                icon: Icon(
                                    liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: liked ? Colors.red : Colors.grey),
                                onPressed: () {
                                  pressed();
                                  favList.writeUserFavs(
                                      codigo, nombreProd, image, context);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Aviso'),
                                          content: Text(
                                              'Producto agregado satisfactoriamente a su lista de favoritos'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('Entendido')),
                                          ],
                                        );
                                      });
                                },
                              )
                            ],
                          ),
                        ),
                        Text(
                          nombreProd,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        Text('Precio: ' +
                            snapshot.data!.docs[index]["pNL"][0].toString())
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
