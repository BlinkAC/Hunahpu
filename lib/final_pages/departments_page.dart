import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cursoflutter/classes/animations.dart';
import 'package:cursoflutter/common%20widgets/side_menu.dart';
import 'package:cursoflutter/final_pages/subdepartments.dart';
import 'package:cursoflutter/services/auth.dart';
import 'package:flutter/material.dart';

class Deparments extends StatefulWidget {
  Deparments({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _DeparmentsState createState() => _DeparmentsState();
}

class _DeparmentsState extends State<Deparments>
    with AutomaticKeepAliveClientMixin<Deparments> {
  late final Stream<QuerySnapshot<Object?>> _widget;

  CollectionReference ref1 = FirebaseFirestore.instance
      .collection("Departamentos")
      .doc('Limpieza')
      .collection('cLimpieza');
  Stream<QuerySnapshot<Object?>> getProds() {
    CollectionReference ref =
        FirebaseFirestore.instance.collection("Departamentos");
    return ref.snapshots();
  }

  navigateToDepts(String nombreDto) {
    Navigator.push(
      context,
      AnimationPage(widget: SubDeparments(nombreDto: nombreDto)),
    );
  }

  @override
  void initState() {
    super.initState();
    _widget = getProds();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      drawer: SideMenu(auth: widget.auth),
      appBar: AppBar(
        title: Text("Departamentos"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _widget,
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List deparments =
                    snapshot.data!.docs.map((doc) => doc.id).toList();
                print(deparments);
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          scrollDirection: Axis.vertical,
                          itemCount: deparments.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              GestureDetector(
                                onTap: () {
                                  navigateToDepts(deparments[index]);
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 500,
                                    height: 100,
                                    margin:
                                        EdgeInsets.only(bottom: 5, right: 8),
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
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            snapshot.data!.docs[index]["image"],
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(deparments[index],
                                                style: TextStyle(fontSize: 17)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ]);
                          }),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
