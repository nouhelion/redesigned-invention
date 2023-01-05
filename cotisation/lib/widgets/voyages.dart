// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
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

            return Card(
              elevation: 5,
              child: ListTile(
                leading: Text(
                  documentSnapshot['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.indigoAccent),
                ),
                title: Text(
                  documentSnapshot['description'],
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
