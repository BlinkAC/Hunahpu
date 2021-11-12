import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursoflutter/products/details_page.dart';
import 'package:elastic_client/elastic_client.dart';
import 'package:flutter/material.dart';
import 'package:elastic_client/elastic_client.dart' as elastic;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchProduct extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () async {
          query = '';
          await searchElasticServer(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchElasticServer(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: Text("En espera de resultados"));

        return _displaySuperheroes(snapshot.data);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchElasticServer(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return Text("En espera de resultados");

        return _displaySuperheroes(snapshot.data);
      },
    );
  }

  Widget _displaySuperheroes(List<String> cityList) {
    print("ESTA ES LA CITY LIST: ");
    print(cityList);
    return ListView.builder(
        itemCount: cityList.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return GestureDetector(
              onTap: () {getDetails(ctxt, cityList[index]);},
              child: ListTile(
                leading: Icon(FontAwesomeIcons.shoppingBag),
                title: Text(cityList[index]),
              ));
        });
  }

  Future searchElasticServer(searchQuery) async {
    final transport = HttpTransport(
        url: 'https://products-collection.es.us-central1.gcp.cloud.es.io:9243',
        authorization:
            basicAuthorization('elastic', 'R6DATUJcAT2u6LNNpFDqKigY'));
    final client = elastic.Client(transport);
    List<String> cityList = <String>[];

    final searchResult = await client.search(
        index: "products",
        type: '_doc',
        query: elastic.Query.term('nombre', ['$searchQuery']),
        source: true);

    print(
        "----------- Found ${searchResult.totalCount} $searchQuery ----------");
    for (final iter in searchResult.hits) {
      Map<dynamic, dynamic> currDoc = iter.doc;
      print(currDoc);
      cityList.add(currDoc['nombre'].toString());
    }

    await transport.close();

    if (searchResult.totalCount <= 0)
      return null;
    else
      return cityList;
  }
}

getDetails(BuildContext context, String nombreProd) async {
  var ref = await FirebaseFirestore.instance
      .collection('Todos')
      .where('nombre', isEqualTo: nombreProd).get();
      if(ref.docs.length!=0){
        var snapshot = ref.docs[0];
        //var data = snapshot.data();
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsPage(
            productDetails: snapshot,
          ),
        ),
      );
        // print(data["image"]);
      }else{
        print("NO SE ENCONTRO");
      }
      
  print(ref);
  // var query = ref.get().then((snapshot) => {snapshot.docs});
  // print(query);
}
