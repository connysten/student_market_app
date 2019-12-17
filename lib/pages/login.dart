import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import "../services/user_details.dart";
import "../services/widgets/login_button.dart";
import "../main.dart";

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Sign In'),
    ));

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    ProviderDetails providerInfo = ProviderDetails(userDetails.providerId);

    List<ProviderDetails> providerData = List<ProviderDetails>();
    providerData.add(providerInfo);

    UserDetails details = UserDetails(
      userDetails.providerId,
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email,
      providerData,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(userDetails: details),
      ),
    );
    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
            builder: (context) =>
                Stack(fit: StackFit.expand, children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.network(
                        "https://whitearkitekter.com/se/wp-content/uploads/sites/3/2019/01/Malardalens-Hogskola-White-Arkitekter-08-3.4-840x1120.jpg",
                        fit: BoxFit.fill,
                        color: Color.fromRGBO(255, 255, 255, 0.6),
                        colorBlendMode: BlendMode.modulate),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: EdgeInsets.symmetric(vertical: 120),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Student App",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SvgPicture.asset(
                            "assets/books.svg",
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              LoginButton(
                                  iconColor: Color(0xff4caf50),
                                  text: "Sign in with Email",
                                  iconData: FontAwesomeIcons.solidEnvelope,
                                  function: () {}),
                              SizedBox(
                                height: 20,
                              ),
                              LoginButton(
                                iconColor: Color(0xffCE107C),
                                text: "Sign in with Google",
                                iconData: FontAwesomeIcons.google,
                                function: () => _signIn(context)
                                    .then((FirebaseUser user) => print(user))
                                    .catchError((e) => print(e)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              LoginButton(
                                iconColor: Color(0xff4754de),
                                text: "Sign in with Facebook",
                                iconData: FontAwesomeIcons.facebookF,
                                function: () {},
                              )
                            ],
                          ),
                        )
                      ])
                ])));
  }
}
