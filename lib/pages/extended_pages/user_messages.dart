import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import "package:student_market_app/services/message.dart";

class UserMessages extends StatefulWidget {
  @override
  _UserMessagesState createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  List<Message> messages = [
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message:
            "Hello! I'm intressted in your book. Please contact me, Hello! I'm intressted in your book. Please contact me, Hello! I'm intressted in your book. Please contact me, Hello! I'm intressted in your book. Please contact me, Hello! I'm intressted in your book. Please contact me, "),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
    Message(
        otherUser: "Testuser",
        otherUserAvatar: "avatar-icon.jpg",
        message: "Hello! I'm intressted in your book. Please contact me"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Messages",
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
        body: ListView.separated(
          
          separatorBuilder: (context, index) => Divider(color: Colors.grey[300],height: 0, thickness: 1,
          ),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: "Delete",
                      color: Colors.red,
                      icon: FontAwesomeIcons.trash,
                      onTap: () {
                        setState(() {
                          messages.removeAt(index);
                        });
                      },
                    ),
                  ],
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      isThreeLine: true,
                      title: Text(messages[index].otherUser),
                      subtitle: Container(
                        width: double.infinity,
                        child: Text(
                          messages[index].message,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                            "assets/${messages[index].otherUserAvatar}"),
                      ),
                    ),
                  ));
            }));
  }
}
