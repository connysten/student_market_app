import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import './global.dart' as global;
import 'package:flutter/material.dart';
import './pages/login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db
            .collection('users')
            .document(u.uid)
            .snapshots()
            .map((snap) => snap.data);
      } else {
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleHandleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;

    updateUserData(user);
    print("Signed in " + user.displayName);

    loading.add(false);
    return user;
  }

  Future<FirebaseUser> facebookHandleSignIn() async{
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: token);
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser user = authResult.user;

    updateUserData(user);

    return user;

  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      "uid": user.uid,
      "email": user.email,
      "photoUrl": user.photoUrl,
      "displayName": user.displayName,
      "lastSeen": DateTime.now()
    }, merge: true);
  }

  Future<void> signOut(BuildContext context) async {
    global.user = null;
    await _googleSignIn.disconnect();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (context)=> Login()), ModalRoute.withName("/home"));
  }
}
