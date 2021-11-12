import 'package:flutter/material.dart';


class UserProfile extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de usuario'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ) ,
      body: Text("Texto de prueba"),
    );
  }
}