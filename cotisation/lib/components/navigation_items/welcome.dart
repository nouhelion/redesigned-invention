// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, unused_field, unused_element, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, unused_local_variable, unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/cotisation.dart';
import 'package:cotisation/components/navigation_items/profil.dart';
import 'package:cotisation/model/dataset.dart';
import 'package:cotisation/components/navigation_items/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _descController = TextEditingController();

final TextEditingController _parti1Controller = TextEditingController();
final TextEditingController _job1Controller = TextEditingController();

final TextEditingController _parti2Controller = TextEditingController();
final TextEditingController _job2Controller = TextEditingController();

final TextEditingController _parti3Controller = TextEditingController();
final TextEditingController _job3Controller = TextEditingController();

final TextEditingController _parti4Controller = TextEditingController();
final TextEditingController _job4Controller = TextEditingController();

class _WelcomeState extends State<Welcome> {
  int pageIndex = 0;
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

  Future addVoyage() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Voyages");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ParticipantPage(),
      ),
    );
    return _collectionRef
        .doc(uid)
        .collection("items")
        .doc()
        .set({
          "title": _nameController.text.trim(),
          "description": _descController.text.trim(),
        })
        .then((value) => print("Added to Database"))
        .catchError((error) => print("Failed to add to Database: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Ajouter un Voyage",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      subtitle: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.tire_repair_rounded),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          hintText: '  Titre',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: ListTile(
                      subtitle: TextFormField(
                        controller: _descController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.list_alt),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          hintText: '  Description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[700],
        onPressed: addVoyage,
        tooltip: 'Add',
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Voyages',
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

class ParticipantPage extends StatefulWidget {
  const ParticipantPage({super.key});

  @override
  State<ParticipantPage> createState() => _ParticipantPageState();
}

class _ParticipantPageState extends State<ParticipantPage> {
  String dropdownValue1 = 'T??che';
  String dropdownValue2 = 'T??che';
  String dropdownValue3 = 'T??che';
  String dropdownValue4 = 'T??che';

  Future<String> getDocumentId() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    var collectionReference = FirebaseFirestore.instance
        .collection("Voyages")
        .doc(uid)
        .collection("items");
    var query = collectionReference.where("title",
        isEqualTo: _nameController.text.trim());
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  Future addParticpant() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("Voyages");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Welcome(),
      ),
    );
    String documentId = await getDocumentId();

    DocumentReference participant1 = _collectionRef
        .doc(uid)
        .collection("items")
        .doc(documentId)
        .collection("participants")
        .doc("Participant1");
    DocumentReference participant2 = _collectionRef
        .doc(uid)
        .collection("items")
        .doc(documentId)
        .collection("participants")
        .doc("Participant2");
    DocumentReference participant3 = _collectionRef
        .doc(uid)
        .collection("items")
        .doc(documentId)
        .collection("participants")
        .doc("Participant3");
    DocumentReference participant4 = _collectionRef
        .doc(uid)
        .collection("items")
        .doc(documentId)
        .collection("participants")
        .doc("Participant4");

    int coti1 = 20, coti2 = 20, coti3 = 20, coti4 = 20;
    Task task1 = tasks.firstWhere((task) => task.task == dropdownValue1);

    coti1 = task1.amount!;

    Task task2 = tasks.firstWhere((task) => task.task == dropdownValue2);

    coti2 = task2.amount!;

    Task task3 = tasks.firstWhere((task) => task.task == dropdownValue3);

    coti3 = task3.amount!;

    Task task4 = tasks.firstWhere((task) => task.task == dropdownValue4);

    coti4 = task4.amount!;

    await Future.wait([
      participant1.set({
        "Nom": _parti1Controller.text.trim(),
        "Tache": dropdownValue1,
        "Cotisation": coti1
      }),
      participant2.set({
        "Nom": _parti2Controller.text.trim(),
        "Tache": dropdownValue2,
        "Cotisation": coti2
      }),
      participant3.set({
        "Nom": _parti3Controller.text.trim(),
        "Tache": dropdownValue3,
        "Cotisation": coti3
      }),
      participant4.set({
        "Nom": _parti4Controller.text.trim(),
        "Tache": dropdownValue4,
        "Cotisation": coti4
      }),
    ]);
    return 'Data added successfully!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text(
            "D??tails du Voyage " + "`" + _nameController.text.trim() + "`"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            Text(
              "Ajouter les participants",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        subtitle: TextFormField(
                          controller: _parti1Controller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: '  Nom',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 220,
                      child: ListTile(
                          subtitle: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.checklist_rounded),
                          /*labelText: 'T??che',
                labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),*/
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue1,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue1 = newValue!;
                          });
                        },
                        items: <String>[
                          'T??che',
                          'Nourriture',
                          'Transport',
                          'Utilit??',
                          'Urgence',
                          'M??dicaments',
                          'H??bergement',
                          'Loisirs',
                          'Assurance',
                          'V??tements',
                          'R??ception',
                          'Cadeaux',
                          'Photographie',
                          'Musique',
                          'D??coration',
                          'Location',
                          'Autres'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        subtitle: TextFormField(
                          controller: _parti2Controller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: '  Nom',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 220,
                      child: ListTile(
                          subtitle: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.checklist_rounded),
                          /*labelText: 'T??che',
                labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),*/
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue2,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue2 = newValue!;
                          });
                        },
                        items: <String>[
                          'T??che',
                          'Nourriture',
                          'Transport',
                          'Utilit??',
                          'Urgence',
                          'M??dicaments',
                          'H??bergement',
                          'Loisirs',
                          'Assurance',
                          'V??tements',
                          'R??ception',
                          'Cadeaux',
                          'Photographie',
                          'Musique',
                          'D??coration',
                          'Location',
                          'Autres'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        subtitle: TextFormField(
                          controller: _parti3Controller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: '  Nom',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 220,
                      child: ListTile(
                          subtitle: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.checklist_rounded),
                          /*labelText: 'T??che',
                labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),*/
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue3,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue3 = newValue!;
                          });
                        },
                        items: <String>[
                          'T??che',
                          'Nourriture',
                          'Transport',
                          'Utilit??',
                          'Urgence',
                          'M??dicaments',
                          'H??bergement',
                          'Loisirs',
                          'Assurance',
                          'V??tements',
                          'R??ception',
                          'Cadeaux',
                          'Photographie',
                          'Musique',
                          'D??coration',
                          'Location',
                          'Autres'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        subtitle: TextFormField(
                          controller: _parti4Controller,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: '  Nom',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 220,
                      child: ListTile(
                          subtitle: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.checklist_rounded),
                          /*labelText: 'T??che',
                labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),*/
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        dropdownColor: Colors.white,
                        value: dropdownValue4,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue4 = newValue!;
                          });
                        },
                        items: <String>[
                          'T??che',
                          'Nourriture',
                          'Transport',
                          'Utilit??',
                          'Urgence',
                          'M??dicaments',
                          'H??bergement',
                          'Loisirs',
                          'Assurance',
                          'V??tements',
                          'R??ception',
                          'Cadeaux',
                          'Photographie',
                          'Musique',
                          'D??coration',
                          'Location',
                          'Autres'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[700],
        onPressed: addParticpant,
        tooltip: 'Add',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
