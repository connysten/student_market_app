import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:student_market_app/pages/extended_pages/user_chat.dart';
import 'package:student_market_app/services/chat_with_other_user.dart';
import 'package:student_market_app/services/messages_database.dart';
import 'package:student_market_app/global.dart' as global;

class DetailAdd extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final int index;

  DetailAdd(this.snapshot, this.index);

  @override
  _DetailAddState createState() => _DetailAddState();
}

class _DetailAddState extends State<DetailAdd> {
  MessagesDatabaseService _messagesDatabaseService = MessagesDatabaseService();
  String otherUser = "";

  final conditions = ['Poor', 'Used', 'Barely used', 'As new'];
  final skick = ['Dåligt', 'Använd', 'Knappt använd', 'Som ny'];
  int index = 0;

  @override
  void initState() {
    getAddUserName().then((val) => setState(() {
          otherUser = val;
        }));
    getConditionIndex();
  }

  Future getAddUserName() async {
    var user =
        await _messagesDatabaseService.getUser(widget.snapshot['userid']);
    return user.displayName;
  }

  void getConditionIndex() {
    index = conditions.indexOf(widget.snapshot['condition']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.darkModeActive == true ? Colors.grey[900] : null,
      appBar: AppBar(
        backgroundColor:
            global.darkModeActive == true ? Colors.black : Colors.orange,
        title: Text(
          global.currentLanguage == global.Language.eng
              ? "Book for sale"
              : "Bok till salu",
          style: TextStyle(
              color:
                  global.darkModeActive == true ? Colors.orange : Colors.black,
              fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: global.darkModeActive == true
                    ? Colors.grey[800]
                    : Colors.grey[300],
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
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
                      widget.snapshot['price'] != 0
                          ? '${widget.snapshot['price'].toString()} kr'
                          : global.currentLanguage == global.Language.eng
                              ? 'Free'
                              : 'Gratis',
                      style: TextStyle(
                          fontSize: 20,
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
                    ),
                    Text(
                      global.currentLanguage == global.Language.eng
                          ? "Uploaded: ${widget.snapshot['timestamp']}"
                          : "Uppladdad: ${widget.snapshot['timestamp']}",
                      style: TextStyle(
                        color: global.darkModeActive == true
                            ? Colors.grey[700]
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      global.currentLanguage == global.Language.eng
                          ? "Condition: "
                          : "Skick: ",
                      style: TextStyle(
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
                    ),
                    Text(
                      global.currentLanguage == global.Language.eng
                          ? conditions[index]
                          : skick[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
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
                      global.currentLanguage == global.Language.eng
                          ? "Description: "
                          : "Beskrivning: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 8, 10, 0),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.snapshot['description'],
                      style: TextStyle(
                          fontSize: 16,
                          color: global.darkModeActive == true
                              ? Colors.grey[300]
                              : null),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        global.currentLanguage == global.Language.eng
                            ? "Seller"
                            : "Säljare",
                        style: TextStyle(
                            color: global.darkModeActive == true
                                ? Colors.grey[700]
                                : Colors.grey[400]),
                      ),
                      Text(
                        otherUser,
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 1,
                            color: global.darkModeActive == true
                                ? Colors.grey[300]
                                : null),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Divider(
                  color: Colors.grey[400],
                ),
              ),
              Row(
                children: <Widget>[
                  FutureBuilder(
                      future: _messagesDatabaseService
                          .getUser(widget.snapshot.data['userid']),
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            widget.snapshot.data['userid'] != global.user.uid) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              color: Colors.orange[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                global.currentLanguage == global.Language.eng
                                    ? "Send Message"
                                    : "Skicka Meddelande",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
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
                        } else if (snapshot.hasData &&
                            widget.snapshot.data['userid'] == global.user.uid) {
                          return Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                color: Colors.orange[300],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  global.currentLanguage == global.Language.eng
                                      ? "Delete ad"
                                      : "Ta bort annons",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: () async => await Firestore.instance
                                    .collection('Annons')
                                    .document(widget.snapshot.documentID)
                                    .delete()
                                    .then((_) => Navigator.pop(context))),
                          );
                        } else {
                          return Container();
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
