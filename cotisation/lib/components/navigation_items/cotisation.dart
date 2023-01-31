// ignore_for_file: prefer_const_constructors, unused_element, non_constant_identifier_names, sort_child_properties_last, prefer_interpolation_to_compose_strings, unnecessary_new, unused_local_variable, unused_field

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/profil.dart';
import 'package:cotisation/components/navigation_items/search.dart';
import 'package:cotisation/components/navigation_items/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Get the user's unique identifier
String uid = user.uid;
CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("Voyages");

class Cotisation extends StatefulWidget {
  const Cotisation({super.key});

  @override
  State<Cotisation> createState() => _CotisationState();
}

String name = '';

class _CotisationState extends State<Cotisation> {
  int pageIndex = 2;
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _collectionRef.doc(uid).collection("items").get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        setState(() {
          items.add(result.data()["title"]);
        });
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      pageIndex = index;

      if (index == 0) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Welcome()));
      }
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search()));
      }
      if (index == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Cotisation()));
      }
      if (index == 3) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 5),
            child: Text(
              "Cotisations",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, position) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: InkWell(
                          onTap: () {
                            name = items[position];
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChartPage(name: name),
                              ),
                            );
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Center(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.show_chart,
                                        size: 50,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      items[position],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )));
                },
                itemCount: items.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Voayges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Cotisation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        currentIndex: pageIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.indigo,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ChartPage extends StatefulWidget {
  final String name;
  const ChartPage({Key? key, required this.name}) : super(key: key);
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late List<List<PieChartSectionData>> _dataList;
  Random random = new Random();
  Future<String> getDocumentId(String voyage) async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    var collectionReference = FirebaseFirestore.instance
        .collection("Voyages")
        .doc(uid)
        .collection("items");
    var query = collectionReference.where("title", isEqualTo: voyage);
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  @override
  void initState() {
    super.initState();
    _dataList = [];
    _getData();
  }

  Future<void> _getData() async {
    String documentId = await getDocumentId(name);
    FirebaseFirestore.instance
        .collection("Voyages")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(documentId)
        .get()
        .then((DocumentSnapshot snapshot) {
      var values = snapshot.data() as Map;
      values.forEach((key, value) {
        var data = <PieChartSectionData>[];
        var document = value as Map;
        document.forEach((key, value) {
          var label = key;
          var number = value;
          data.add(
            PieChartSectionData(
              value: number,
              color: Color.fromARGB(255, random.nextInt(255),
                  random.nextInt(255), random.nextInt(255)),
              title: label,
            ),
          );
        });
        setState(() {
          _dataList.add(data);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cotisations du Voyage " + name),
      ),
    );
  }
}
