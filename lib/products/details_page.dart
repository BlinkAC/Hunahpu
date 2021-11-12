import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.productDetails});
  final DocumentSnapshot productDetails;
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Detalles de producto"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              widget.productDetails["nombre"],
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            Image.network(
              widget.productDetails["image"],
              width: 280,
              height: 370,
              fit: BoxFit.cover,
              
            ),
            SizedBox(height: 15,),
            Text(
              "Descripcion de producto:",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 380,
              child: Text(widget.productDetails["descripcion"],
                  textAlign: TextAlign.justify, style: TextStyle(fontSize: 17)),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Comparativa de precios",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  SizedBox(height:4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Precio Soriana' +
                        widget.productDetails["pNL"][0].toString()),
                  ),
                ],
              ),
            )

            // Text("Precio HEB: " +
            //     widget.productDetails["pHEB"].toString(), textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            // Text("Precio Soriana: " +
            //     widget.productDetails["pSoriana"].toString(), textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            // Text("Precio Waltmart: " +
            //     widget.productDetails["pWaltmart"].toString(),textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
