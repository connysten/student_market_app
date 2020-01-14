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

  Observable<FirebaseUser> _user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    _user = Observable(_auth.onAuthStateChanged);
    profile = _user.switchMap((FirebaseUser u) {
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
    FirebaseUser _user = authResult.user;

    googleUpdateUserData(_user);
    print("Signed in " + _user.displayName);

    loading.add(false);
    return _user;
  }

  Future<FirebaseUser> facebookHandleSignIn() async {
    final FacebookLoginResult result = await _facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: token);
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    FirebaseUser _user = authResult.user;

    facebookUpdateUserData(_user, token);

    return _user;
  }

  void googleUpdateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      "uid": user.uid,
      "email": user.email,
      "photoUrl": user.photoUrl,
      "displayName": user.displayName,
      "lastSeen": DateTime.now()
    }, merge: true);
  }

  void facebookUpdateUserData(FirebaseUser user, String token) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    String photoUrl =
        "https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=$token";
    return ref.setData({
      "uid": user.uid,
      "email": user.email,
      "photoUrl": photoUrl,
      "displayName": user.displayName,
      "lastSeen": DateTime.now()
    }, merge: true);
  }

  Future<void> signOut(BuildContext context) async {
    if (global.user.providerData[1].providerId == "google.com") {
      await _googleSignIn.disconnect();
    } else if (global.user.providerData[1].providerId == "facebook.com") {
      await _facebookLogin.logOut();
    } else {}
    global.user = null;
    await _auth.signOut();
    _user = null;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        ModalRoute.withName("/home"));
  }
}
