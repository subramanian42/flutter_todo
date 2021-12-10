import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolist_1/pages/homepage.dart';

class Authentication {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  CollectionReference taskRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('Task');
  static Query<Map> query = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('Task');
  User? user;

  Query<Map> getQuery() {
    return query;
  }

  CollectionReference getTaskReference() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Task');
  }

  void checkUser(context) {
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tasklist() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('Task')
        .snapshots();
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> googlesignin() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    User? user = userCredential.user;
    createUserInFireStore(user);
    return user;
  }

  createUserInFireStore(User? user) async {
    //final usersRef = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot doc = await usersRef.doc(user!.uid).get();
    if (!doc.exists) {
      await usersRef.doc(user.uid).set(
        {
          'username': user.displayName,
          'userid': user.uid,
        },
        SetOptions(merge: true),
      );
    }
  }
}

final Authentication authenticatedUser = Authentication();
