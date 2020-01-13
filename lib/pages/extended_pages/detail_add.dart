import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/pages/extended_pages/user_chat.dart';
import 'package:student_market_app/pages/extended_pages/user_messages.dart';
import 'package:student_market_app/pages/search.dart';
import 'package:student_market_app/services/chat_with_other_user.dart';
import 'package:student_market_app/services/messages_database.dart';

class DetailAdd extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final int index;

  DetailAdd(this.snapshot, this.index);

  MessagesDatabaseService _messagesDatabaseService = MessagesDatabaseService();

  @override
  _DetailAddState createState() => _DetailAddState();
}

class _DetailAddState extends State<DetailAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: new Hero(
                    tag: 'Add${widget.index}',
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          //margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          height: MediaQuery.of(context).size.height / 2.5,
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: widget.snapshot['imageUrl'],
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                widget.snapshot['title'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text("${widget.snapshot['price'].toString()} kr"),
            ],
          ),
          Row(
            children: <Widget>[
              Text("\n${widget.snapshot['description'].toString()}"),
            ],
          ),
          Row(
            children: <Widget>[
              FutureBuilder(
                  future: widget._messagesDatabaseService
                      .getUser(widget.snapshot.data['userid']),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: Icon(
                          FontAwesomeIcons.envelope,
                        ),
                        onPressed: () async => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserChat(
                                chat:
                                    ChatWithOtherUser(otherUser: snapshot.data),
                              ),
                            )),
                      );
                    }else{
                      return Text("Trying to access message");
                    }
                  })
            ],
          ),
        ],
      ),
    );
  }
}
