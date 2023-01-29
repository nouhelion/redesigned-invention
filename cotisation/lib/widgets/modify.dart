// ignore_for_file: unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
User user = _auth.currentUser!;

// Get the user's unique identifier
String uid = user.uid;
CollectionReference _collectionRef =
    FirebaseFirestore.instance.collection("Voyages");

Widget modifyData(String voyage) {
  return Scaffold(
     
  );
}
