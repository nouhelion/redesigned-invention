// ignore_for_file: prefer_const_constructors, unused_element, unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/cotisation.dart';
import 'package:cotisation/components/navigation_items/profil.dart';
import 'package:cotisation/components/navigation_items/welcome.dart';
import 'package:cotisation/model/dataset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser!;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// Get the user's unique identifier
String uid = user.uid;
CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("Voyages");

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

String name = '';

class _SearchState extends State<Search> {
  int pageIndex = 1;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50, bottom: 5),
            child: Text(
              "Voyages",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, position) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: InkWell(
                          child: Center(
                        child: Column(
                          children: [
                            Center(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0)),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.time_to_leave_sharp,
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.visibility,
                                    color: Colors.green[300],
                                  ),
                                  onTap: () {
                                    name = items[position];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ViewPage(name: name),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue[300],
                                  ),
                                  onTap: () {
                                    name = items[position];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ModifyPage(name: name),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red[300],
                                  ),
                                  onTap: () async {
                                    String documentId =
                                        await getDocumentId(items[position]);
                                    FirebaseFirestore.instance
                                        .collection("Voyages")
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .collection("items")
                                        .doc(documentId)
                                        .delete();
                                  },
                                ),
                              ],
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

String viewTache1 = 'Tache1',
    viewTache2 = 'Tache2',
    viewTache3 = 'Tache3',
    viewTache4 = 'Tache4';

class ViewPage extends StatefulWidget {
  final String name;
  const ViewPage({Key? key, required this.name}) : super(key: key);

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
    var query = collectionReference.where("title", isEqualTo: name);
    var querySnapshot = await query.get();
    return querySnapshot.docs.first.id;
  }

  Future<void> getVoyage() async {
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
        viewTache1 = data['Tache'];
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
        viewTache2 = data['Tache'];
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
        viewTache3 = data['Tache'];
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
        viewTache4 = data['Tache'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getVoyage();
  }

  @override
  void dispose() {
    // Clear the counter when the widget is removed from the tree
    String viewTache1 = 'Tache1',
        viewTache2 = 'Tache2',
        viewTache3 = 'Tache3',
        viewTache4 = 'Tache4';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Contenu du voyage ' + name),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              name,
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
                    value: viewTache1,
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
                    value: viewTache2,
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
                    value: viewTache3,
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
                    value: viewTache4,
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
  final String name;
  const ModifyPage({Key? key, required this.name}) : super(key: key);
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
    var query = collectionReference.where("title", isEqualTo: name);
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

      dropdownValue1 = data['Tache'];
    });
    voyageDocument
        .collection("participants")
        .doc("Participant2")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti2Controller.text = data['Nom'];

      dropdownValue2 = data['Tache'];
    });
    voyageDocument
        .collection("participants")
        .doc("Participant3")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti3Controller.text = data['Nom'];

      dropdownValue3 = data['Tache'];
    });
    voyageDocument
        .collection("participants")
        .doc("Participant4")
        .get()
        .then((snapshot) async {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
      // Set the data as the initial value of the TextEditingController
      _parti4Controller.text = data['Nom'];

      dropdownValue4 = data['Tache'];
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
      participant2.update({
        "Nom": _parti2Controller.text.trim(),
        "Tache": dropdownValue2,
        "Cotisation": coti2
      }),
      participant3.update({
        "Nom": _parti3Controller.text.trim(),
        "Tache": dropdownValue3,
        "Cotisation": coti3
      }),
      participant4.update({
        "Nom": _parti4Controller.text.trim(),
        "Tache": dropdownValue4,
        "Cotisation": coti4
      }),
    ]);
  }

  @override
  void initState() {
    super.initState();
    getCurrentVoyage();
  }

  @override
  void dispose() {
    // Clear the counter when the widget is removed from the tree
    String dropdownValue1 = 'Tache1',
        dropdownValue2 = 'Tache2',
        dropdownValue3 = 'Tache3',
        dropdownValue4 = 'Tache4';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Modification du voyage ' + name),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              name,
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
                color: Colors.teal[700],
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
