
import 'package:cursoflutter/common%20widgets/side_menu.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(auth: auth),
      appBar: AppBar(
        title: Text("Rebajas"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Text("NANAy"),
    );
  }
}
