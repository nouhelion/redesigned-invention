// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_import, avoid_unnecessary_containers, unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotisation/components/navigation_items/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser!;

// Get the user's unique identifier
String uid = user.uid;
CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("Voyages");

Future<String> getDocumentId(String name) async {
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
//String documentId = await getDocumentId();

Future<void> View(String name) async {
  String documentId = await getDocumentId(name);
}

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

/*Widget FetchParticipants(String collectionName) {
  return StreamBuilder(
    stream: _collectionRef
        .doc(uid)
        .collection("items")
        .doc()
        .collection("participants")
        .snapshots(),
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPage(),
                    ),
                  );
                },
                title: Text(
                  data['description'],
                ),
              ),
            );
          });
    },
  );
}*/

class ViewPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: Text('Contenu du voyage ' + widget.data['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'participants',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You are logged in',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class ModifyPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ModifyPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ModifyPage> createState() => _ModifyPageState();
}

class _ModifyPageState extends State<ModifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[400],
        title: Text('Modification du voyage ' + widget.data['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'participants',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'You are logged in',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
