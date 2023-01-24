// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_import

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

Widget FetchData(String collectionName) {
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PartPage(),
                    ),
                  );
                },
                title: Text(
                  data['description'],
                ),
                trailing: GestureDetector(
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
            );
          });
    },
  );
}

class PartPage extends StatefulWidget {
  const PartPage({super.key});

  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
