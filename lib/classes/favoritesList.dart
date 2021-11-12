import 'dart:convert';
import 'dart:io';
import 'package:cursoflutter/classes/productModel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FavoriteList {

  _favoritesListExists(
    String codigoN, String nombre, String image, BuildContext context) async {
     bool productInList = false;
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    print('EL ARCHIVO EXISTE');

    
    //Se carga el producto por agregar
    ProductList productItem =
        new ProductList(codigo: codigoN, nombre: nombre, image: image);

    //Lee el archivo
    final fileToRead =
        await File("${directory!.path}/UserFavs.json").readAsString();

    //Se convierte a list
    final list = json.decode(fileToRead) as List<dynamic>;
    list.map((e) => ProductList.fromJson(e)).toList();

    for (int i = 0; i < list.length; i++) {
      var prueba = list[i]['codigo'];
      if(prueba == codigoN){
        productInList = true;
      }
    }

    if(!productInList){
      print("SE AGREGO");
      //se agrega
        list.add(productItem);

        //Se escribe
        String fileContent = jsonEncode(list);
        return File("${directory.path}/UserFavs.json")
            .writeAsString(fileContent);
    }else {
        AlertDialog(
            title: Text('Aviso'),
            content: Text(
                'Parece que este producto ya esta en su lista de favoritos'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Entendido')),
            ]);
      }
  }

  _favoritesListNoExists(String codigoN, String nombre, String image) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    //Crea el archivo json en la direccion
    File file = await File("${directory!.path}/UserFavs.json").create();

    //Se carga el producto por agregar
    ProductList productItem =
        new ProductList(codigo: codigoN, nombre: nombre, image: image);

    //se agrega
    List<ProductList> list = [];
    list.add(productItem);

    // Convert json object to String data using json.encode() method
    String fileContent = jsonEncode(list);
    return await file.writeAsString(fileContent);
  }

  writeUserFavs(
      String codigoN, String nombre, String image, BuildContext context) async {
    // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();

    //Revisa si existe el archivo
    if (await File("${directory!.path}/UserFavs.json").exists()) {
      _favoritesListExists(codigoN, nombre, image, context);
    } else {
      _favoritesListNoExists(codigoN, nombre, image);
    }

    // final fileToRead =
    //     await File("${directory.path}/UserFavs.json").readAsString();
  }

  deleteUserFavs(String codigoProd) async{
     Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();


      final fileToRead =
        await File("${directory!.path}/UserFavs.json").readAsString();

          final list = json.decode(fileToRead) as List<dynamic>;
    list.map((e) => ProductList.fromJson(e)).toList();

      for (int i = 0; i < list.length; i++) {
      var prueba = list[i]['codigo'];
      if(prueba == codigoProd){
        list.remove(list[i]);
        String listP = json.encode(list);
        return File("${directory.path}/UserFavs.json")
            .writeAsString(listP);
        
      }
    }
  }
}
