import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool signedIn = false;
  final usersRef = FirebaseFirestore.instance.collection('users');
/*   CollectionReference taskRef = FirebaseFirestore.instance
      .collection('users')
      .doc(authUser.user!.uid)
      .collection('Task'); */
  User? user;

  Future<void> signOut() async {
    await googleSignIn.disconnect();
    await firebaseAuth.signOut();
  }

  checkUser() {
    if (firebaseAuth.currentUser != null) {
      googleSignIn.signInSilently();
    }
  }

  googlesignin() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    signedIn = true;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);
    user = userCredential.user;
    createUserInFireStore(user);
    return user;
  }

  createUserInFireStore(User? user) async {
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

Authentication authUser = Authentication();
