import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/pages/extended_pages/user_chat.dart';
import 'package:student_market_app/pages/extended_pages/user_messages.dart';
import 'package:student_market_app/pages/search.dart';
import 'package:student_market_app/services/chat_with_other_user.dart';
import 'package:student_market_app/services/messages_database.dart';
import 'package:student_market_app/global.dart' as global;
import 'package:student_market_app/pages/profile.dart';

class Empty extends StatefulWidget {
  @override
  _EmptyState createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}
