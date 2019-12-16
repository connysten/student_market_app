import 'package:flutter/material.dart';
import 'package:student_market_app/services/user_details.dart';

class Profile extends StatefulWidget {
  final UserDetails userDetails;
  @override
  _ProfileState createState() => _ProfileState();

  Profile({this.userDetails});
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(widget.userDetails.userEmail),
      ),
    );
  }
}
