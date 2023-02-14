// ignore_for_file: prefer_const_constructors, unused_element, non_constant_identifier_names, sort_child_properties_last, prefer_interpolation_to_compose_strings, unnecessary_new, unused_local_variable, unused_field, avoid_unnecessary_containers, prefer_final_fields, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/profil.dart';
import 'package:cotisation/components/navigation_items/search.dart';
import 'package:cotisation/components/navigation_items/welcome.dart';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                                        color: Colors.teal[700],
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
        selectedItemColor: Colors.teal[700],
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

String tache1 = 'tache1',
    tache2 = 'tache2',
    tache3 = 'tache3',
    tache4 = 'tache4';
double montant1 = 0.0, montant2 = 0.0, montant3 = 0.0, montant4 = 0.0;

class _ChartPageState extends State<ChartPage> {
  Future<String> getDocumentId(String voyage) async {
    User user = _auth.currentUser!;
    String uid = user.uid;
    var collectionReference = FirebaseFirestore.instance
        .collection("Voyages")
        .doc(uid)
        .collection("items");
    var query = collectionReference.where("title", isEqualTo: voyage);
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  Map<String, double> dataMap = {
    "Utilité": 1000.0,
    "Transport": 2000.0,
    "Nourriture": 500.0,
    "Location": 2000.0,
  };
  Future<void> _getData() async {
    String documentId = await getDocumentId(name);
    User user = _auth.currentUser!;
    String uid = user.uid;
    CollectionReference usersCollection =
        _firestore.collection('Voyages').doc(uid).collection("items");
    DocumentReference voyageDocument = usersCollection.doc(documentId);

    List<String> tache = [tache1, tache2, tache3, tache4];
    List<double> montant = [montant1, montant2, montant3, montant4];
    List<Future> futures = [];

    for (int i = 0; i < 4; i++) {
      futures.add(voyageDocument
          .collection("participants")
          .doc("Participant${i + 1}")
          .get());
    }

    await Future.wait(futures).then((snapshots) async {
      for (int i = 0; i < 4; i++) {
        setState(() {
          tache[i] = snapshots[i].data()['Tache'].toString();
          montant[i] = snapshots[i].data()['Cotisation'].toDouble();
        });
      }
    });

    dataMap = {
      tache[0]: montant[0],
      tache[1]: montant[1],
      tache[2]: montant[2],
      tache[3]: montant[3],
    };
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  final colorList = <Color>[
    const Color(0xff00796b),
    const Color(0xff2e9572),
    const Color(0xff59b075),
    const Color(0xff88ca73),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cotisations du Voyage ${widget.name}"),
          backgroundColor: Colors.teal[700],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: _getData(),
            builder: (context, snapshot) {
              return PieChart(
                dataMap: dataMap,
                animationDuration: Duration(milliseconds: 800),
                colorList: colorList,
              );
            },
          ),
        ));
  }
}
