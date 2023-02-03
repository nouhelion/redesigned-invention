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

String tache1 = ' ', tache2 = ' ', tache3 = ' ', tache4 = ' ';
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

  @override
  void initState() {
    super.initState();

    _getData();
    print(tache1);
  }

  Future<void> _getData() async {
    String documentId = await getDocumentId(name);
    User user = _auth.currentUser!;
    String uid = user.uid;
    CollectionReference usersCollection =
        _firestore.collection('Voyages').doc(uid).collection("items");
    DocumentReference voyageDocument = usersCollection.doc(documentId);

    voyageDocument
        .collection("participants")
        .doc("Participant1")
        .get()
        .then((snapshot) async {
      Map<String, double> data = snapshot.data() as Map<String, double>;
      setState(() {
        tache1 = data['Tache'].toString();
        montant1 = data['Cotisation']!;
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant2")
        .get()
        .then((snapshot) async {
      Map<String, double> data = snapshot.data() as Map<String, double>;
      setState(() {
        tache2 = data['Tache'].toString();
        montant2 = data['Cotisation']!;
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant3")
        .get()
        .then((snapshot) async {
      Map<String, double> data = snapshot.data() as Map<String, double>;
      setState(() {
        tache3 = data['Tache'].toString();
        montant3 = data['Cotisation']!;
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant4")
        .get()
        .then((snapshot) async {
      Map<String, double> data = snapshot.data() as Map<String, double>;
      setState(() {
        tache4 = data['Tache'].toString();
        montant4 = data['Cotisation']!;
      });
    });
  }

  Map<String, double> dataMap = {
    "Tache1": 2000,
    "Tache2": 500,
    "Tache3": 400,
    "Tache4": 200,
  };

  @override
  Widget build(BuildContext context) {
    print(tache1);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cotisations du Voyage " + tache1),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PieChart(
            dataMap: dataMap,
          ),
        ));
  }
}
