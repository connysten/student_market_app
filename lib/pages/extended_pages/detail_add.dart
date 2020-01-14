import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
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
  //var otherUser = _messagesDatabaseService.getUser(widget.snapshot['userid']);

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        child: Hero(
                          tag: 'Add${widget.index}',
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Container(
                                //margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: widget.snapshot['imageUrl'],
                                  fit: BoxFit.contain,
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(children: <Widget>[
                    Text(
                      widget.snapshot['title'],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${widget.snapshot['price'].toString()} kr",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "Uploaded: ${widget.snapshot['timestamp']}",
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text("Condition: "),
                    Text(
                      "${widget.snapshot['condition']}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Description",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8, 10, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Text("Sold by", style: TextStyle(
                      color: Colors.grey[400],
                    ),),
                    Text("Dennis Tagesson",style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1
                    ),)
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(color: Colors.grey[400],),
              ),

              Row(
                children: <Widget>[
                  FutureBuilder(
                      future: widget._messagesDatabaseService
                          .getUser(widget.snapshot.data['userid']),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              color: Colors.orange[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text("Send Message", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                              ),),
                              onPressed: () async => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserChat(
                                      chat: ChatWithOtherUser(
                                          otherUser: snapshot.data),
                                    ),
                                  )),
                            ),
                          );
                        } else {
                          return Text("Trying to access message");
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
