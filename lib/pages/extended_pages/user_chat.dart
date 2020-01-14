import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_market_app/services/chat_with_other_user.dart';
import '../../global.dart';

class UserChat extends StatefulWidget {
  final ChatWithOtherUser chat;

  UserChat({Key key, this.chat}) : super(key: key);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  initState() {
    super.initState();
    checkChatId();
  }

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      if (widget.chat.chatId == null) {
        var docRef = await Firestore.instance
            .collection('chats')
            .add({'otherUser': widget.chat.otherUser.uid, 'user': user.uid});
        await Firestore.instance
            .collection('chats')
            .document(docRef.documentID)
            .collection('messages')
            .add({
          "text": messageController.text,
          "from": user.displayName,
          "timestamp": DateTime.now()
        });
        widget.chat.chatId = docRef.documentID;
      } else {
        await Firestore.instance
            .collection("chats")
            .document(widget.chat.chatId)
            .collection("messages")
            .add({
          "text": messageController.text,
          "from": user.displayName,
          "timestamp": DateTime.now()
        });
      }
      if (widget.chat.otherChatId == null) {
        var docRef = await Firestore.instance.collection('chats').add({
          'user': widget.chat.otherUser.uid,
          'otherUser': user.uid,
        });
        await Firestore.instance
            .collection('chats')
            .document(docRef.documentID)
            .collection('messages')
            .add({
          "text": messageController.text,
          "from": user.displayName,
          "timestamp": DateTime.now()
        });
        widget.chat.otherChatId = docRef.documentID;
      } else {
        await Firestore.instance
            .collection("chats")
            .document(widget.chat.otherChatId)
            .collection("messages")
            .add({
          "text": messageController.text,
          "from": user.displayName,
          "timestamp": DateTime.now()
        });
      }
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: widget.chat.chatId != null
                    ? StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('chats')
                            .document(widget.chat.chatId)
                            .collection('messages')
                            .orderBy('timestamp', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                  strokeWidth: 8,
                                ),
                            );

                          List<DocumentSnapshot> docs = snapshot.data.documents;

                          var messages = docs
                              .map((doc) => ChatMessage(
                                    from: doc.data['from'],
                                    text: doc.data['text'],
                                    me: user.displayName == doc.data['from'],
                                  ))
                              .toList()
                              .reversed;

                          return ListView(
                            shrinkWrap: true,
                            reverse: true,
                            controller: scrollController,
                            children: <Widget>[
                              ...messages,
                            ],
                          );
                        },
                      )
                    : Container(),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              padding: EdgeInsets.symmetric(horizontal: 1),
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      controller: messageController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: "Type Here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  SendButton(
                    callback: callback,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkChatId() async {
    if (widget.chat.chatId == null) {
      await Firestore.instance
          .collection('chats')
          .where('otherUser', isEqualTo: widget.chat.otherUser.uid)
          .where('user', isEqualTo: user.uid)
          .getDocuments()
          .then((doc) async {
        if (doc.documents.isNotEmpty) {
          setState(() {
            widget.chat.chatId = doc.documents[0].documentID;
          });
        }
      });
    }

    if (widget.chat.otherChatId == null) {
      await Firestore.instance
          .collection('chats')
          .where('user', isEqualTo: widget.chat.otherUser.uid)
          .where('otherUser', isEqualTo: user.uid)
          .getDocuments()
          .then((doc) async {
        if (doc.documents.isNotEmpty) {
          setState(() {
            widget.chat.otherChatId = doc.documents[0].documentID;
          });
        }
      });
    }
  }
}

class SendButton extends StatelessWidget {
  final VoidCallback callback;

  const SendButton({Key key, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.send),
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.orange,
        onPressed: callback);
  }
}

class ChatMessage extends StatelessWidget {
  final String from;
  final String text;
  final bool me;

  const ChatMessage({Key key, this.from, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              me ? "Me" : from,
            ),
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Material(
              color: me ? Colors.green[200] : Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
