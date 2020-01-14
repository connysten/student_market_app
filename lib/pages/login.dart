import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import "../services/widgets/login_button.dart";
import "../main.dart";
import '../auth_service.dart';
import '../global.dart' as global;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.orange[300],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset("assets/mdh-library.jpg",
                  fit: BoxFit.fill,
                  color: Color.fromRGBO(255, 255, 255, 0.1),
                  colorBlendMode: BlendMode.modulate),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.grey[800], blurRadius: 5)
                          ],
                        ),
                        child: Image.asset(
                            "assets/pngfuel.com.png",
                            height: 100,
                          ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            LoginButton(
                              iconColor: Color(0xff4caf50),
                              text: "Sign in with Mail",
                              iconData: FontAwesomeIcons.solidEnvelope,
                              function: () {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            LoginButton(
                              iconColor: Color(0xffCE107C),
                              text: "Sign in with Google",
                              iconData: FontAwesomeIcons.google,
                              function: () async {
                                global.user = await global.authService
                                    .googleHandleSignIn();
                                if (global.user != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            LoginButton(
                              iconColor: Color(0xff4754de),
                              text: "Sign in with Facebook",
                              iconData: FontAwesomeIcons.facebookF,
                              function: () async {
                                global.user = await global.authService
                                    .facebookHandleSignIn();
                                if (global.user != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Home()));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
