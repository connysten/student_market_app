import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/pages/extended_pages/user_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "package:student_market_app/services/chat.dart";
import 'package:student_market_app/services/chat_with_other_user.dart';
import 'package:student_market_app/services/widgets/alert.dart';
import '../../global.dart';
import '../../services/messages_database.dart';

class UserMessages extends StatefulWidget {
  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  MessagesDatabaseService _repo = MessagesDatabaseService();
  Alert alert = Alert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: _repo.getStream(),
        builder:
            (BuildContext c, AsyncSnapshot<List<ChatWithOtherUser>> snapshot) {
          return snapshot.hasData
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],
                    height: 0,
                    thickness: 1,
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: "Delete",
                          color: Colors.red,
                          icon: FontAwesomeIcons.trash,
                          onTap: () {
                            setState(() {
                              alert.removeChat(
                                  context, snapshot.data[index].chatId);
                            });
                          },
                        ),
                      ],
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserChat(
                              chat: snapshot.data[index],
                            ),
                          ),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                            isThreeLine: true,
                            title: Text(
                                snapshot.data[index].otherUser.displayName),
                            subtitle: Container(
                              width: double.infinity,
                              child: Text(
                                snapshot.data[index].lastMessage,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  "${snapshot.data[index].otherUser.photoUrl}"),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
