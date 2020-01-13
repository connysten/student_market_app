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

  Future<void> callback() async {
    if (messageController.text.length > 0) {
      await Firestore.instance
          .collection("chats")
          .document(widget.chat.chatId)
          .collection("messages")
          .add({
        "text": messageController.text,
        "from": user.displayName,
        "timestamp": DateTime.now()
      });
      var docRef = await Firestore.instance
          .collection('chats')
          .document(widget.chat.otherChatId)
          .get()
          .then((doc) {
        if (doc.exists) {
          return true;
        } else {
          return false;
        }
      });

      if (!docRef) {
        Firestore.instance.runTransaction((Transaction trans) async {
          await Firestore.instance.collection('chats').add({
            'otherUser': user.uid,
            'user': widget.chat.otherUser.uid,
            'message': {
              "text": messageController.text,
              "from": user.displayName,
              "timestamp": DateTime.now()
            }
          });
        });
        messageController.clear();
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('chats')
                      .document(widget.chat.chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                        child: Center(child: CircularProgressIndicator()),
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
                ),
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => callback(),
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type Here...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
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
