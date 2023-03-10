// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_import, avoid_unnecessary_containers, unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Get the user's unique identifier
String uid = user.uid;
CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("Voyages");

//String documentId = await getDocumentId();

Widget FetchVoyage(String collectionName) {
  return StreamBuilder(
    stream: _collectionRef.doc(uid).collection("items").snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return const Center(
          child: Text("Something is wrong"),
        );
      }

      return ListView.builder(
          itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
          itemBuilder: (_, index) {
            DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
            Map<String, dynamic> data =
                documentSnapshot.data()! as Map<String, dynamic>;
            return Card(
              elevation: 5,
              child: ListTile(
                leading: Text(
                  data['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                ),
                /*onTap: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPage(),
                    ),
                  );
                },*/
                title: Text(
                  data['description'],
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            right: 10), // add space between the icons
                        child: GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red[300],
                          ),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection(collectionName)
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("items")
                                .doc(documentSnapshot.id)
                                .delete();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue[300],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifyPage(data: data),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          child: Icon(
                            Icons.visibility,
                            color: Colors.green[300],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPage(data: data),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    },
  );
}

class ViewPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Future<String> getDocumentId() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    var collectionReference = FirebaseFirestore.instance
        .collection("Voyages")
        .doc(uid)
        .collection("items");
    var query =
        collectionReference.where("title", isEqualTo: widget.data['title']);
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  Future<void> getCurrentVoyage() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;

    // Get a reference to the 'users' collection
    CollectionReference usersCollection =
        _firestore.collection('Voyages').doc(uid).collection("items");
    String documentId = await getDocumentId();
    // Get a reference to the document with the user's data
    DocumentReference voyageDocument = usersCollection.doc(documentId);

    // Get the voyage from the document
    voyageDocument.get().then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _nameController.text = data['title'];
      _descController.text = data['description'];
    });

    // Get the participants from the document
    voyageDocument
        .collection("participants")
        .doc("Participant1")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti1Controller.text = data['Nom'];
      setState(() {
        dropdownValue1 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant2")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti2Controller.text = data['Nom'];
      setState(() {
        dropdownValue2 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant3")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti3Controller.text = data['Nom'];
      setState(() {
        dropdownValue3 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant4")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti4Controller.text = data['Nom'];
      setState(() {
        dropdownValue4 = data['Tache'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentVoyage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: Text('Contenu du voyage ' + widget.data['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              widget.data['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 220,
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _descController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _parti1Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue1,
                    onChanged: null,
                    items: <String>[
                      'T??che1',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _parti2Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue2,
                    onChanged: null,
                    items: <String>[
                      'T??che2',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _parti3Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue3,
                    onChanged: null,
                    items: <String>[
                      'T??che3',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _parti4Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue4,
                    onChanged: null,
                    items: <String>[
                      'T??che4',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

final TextEditingController _nameController = TextEditingController();
final TextEditingController _descController = TextEditingController();

final TextEditingController _parti1Controller = TextEditingController();

final TextEditingController _parti2Controller = TextEditingController();

final TextEditingController _parti3Controller = TextEditingController();

final TextEditingController _parti4Controller = TextEditingController();
String dropdownValue1 = 'T??che1';
String dropdownValue2 = 'T??che2';
String dropdownValue3 = 'T??che3';
String dropdownValue4 = 'T??che4';

class ModifyPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ModifyPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  Future<String> getDocumentId() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;
    var collectionReference = FirebaseFirestore.instance
        .collection("Voyages")
        .doc(uid)
        .collection("items");
    var query =
        collectionReference.where("title", isEqualTo: widget.data['title']);
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  Future<void> getCurrentVoyage() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;

    // Get a reference to the 'users' collection
    CollectionReference usersCollection =
        _firestore.collection('Voyages').doc(uid).collection("items");
    String documentId = await getDocumentId();
    // Get a reference to the document with the user's data
    DocumentReference voyageDocument = usersCollection.doc(documentId);

    // Get the voyage from the document
    voyageDocument.get().then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _nameController.text = data['title'];
      _descController.text = data['description'];
    });

    // Get the participants from the document
    voyageDocument
        .collection("participants")
        .doc("Participant1")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti1Controller.text = data['Nom'];
      setState(() {
        dropdownValue1 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant2")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti2Controller.text = data['Nom'];
      setState(() {
        dropdownValue2 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant3")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti3Controller.text = data['Nom'];
      setState(() {
        dropdownValue3 = data['Tache'];
      });
    });
    voyageDocument
        .collection("participants")
        .doc("Participant4")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti4Controller.text = data['Nom'];
      setState(() {
        dropdownValue4 = data['Tache'];
      });
    });
  }

  Future<void> updateVoyage() async {
    // Get a reference to the current user
    User user = _auth.currentUser!;

    // Get the user's unique identifier
    String uid = user.uid;

    // Get a reference to the 'users' collection
    CollectionReference usersCollection = _firestore.collection('Voyages');
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

    await Future.wait([
      participant1
          .set({"Nom": _parti1Controller.text.trim(), "Tache": dropdownValue1}),
      participant2
          .set({"Nom": _parti2Controller.text.trim(), "Tache": dropdownValue2}),
      participant3
          .set({"Nom": _parti3Controller.text.trim(), "Tache": dropdownValue3}),
      participant4
          .set({"Nom": _parti4Controller.text.trim(), "Tache": dropdownValue4}),
    ]);
  }

  @override
  void initState() {
    super.initState();
    getCurrentVoyage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: Text('Modification du voyage ' + widget.data['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              widget.data['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: 220,
                  child: ListTile(
                    subtitle: TextFormField(
                      enabled: false,
                      controller: _descController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    subtitle: TextFormField(
                      controller: _parti1Controller,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue1,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue1 = newValue!;
                      });
                    },
                    items: <String>[
                      'T??che1',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue2,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue2 = newValue!;
                      });
                    },
                    items: <String>[
                      'T??che2',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue3,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue3 = newValue!;
                      });
                    },
                    items: <String>[
                      'T??che3',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
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
                            borderRadius: BorderRadius.all(Radius.circular(8))),
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
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    dropdownColor: Colors.white,
                    value: dropdownValue4,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue4 = newValue!;
                      });
                    },
                    items: <String>[
                      'T??che4',
                      'Nourriture',
                      'Transport',
                      'Utilit??',
                      'Urgence',
                      'M??dicaments',
                      'H??bergement',
                      'Loisirs',
                      'Assurance',
                      'V??tements',
                      'Autres',
                      'R??ception',
                      'Cadeaux',
                      'Photographie',
                      'Musique',
                      'D??coration',
                      'Location',
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
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                    top: BorderSide(color: Colors.black),
                    left: BorderSide(color: Colors.black),
                    right: BorderSide(color: Colors.black),
                  )),
              child: MaterialButton(
                minWidth: 120,
                height: 60,
                onPressed: updateVoyage,
                color: Colors.indigo,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Modifier",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  