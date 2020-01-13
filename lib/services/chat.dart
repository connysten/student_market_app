import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String otherUser;
  String otherUserAvatar;
  String message;
  String chatId;

  Chat({this.otherUser, this.otherUserAvatar, this.message, this.chatId});

  // static Chat getInfo(String uid, String chatId) async{
  //   retur
  // }

  // factory Chat.getInfo(String uid, String chatId) {
  //   String displayName;
  //   String photoUrl;
  //   String latestMessage;

  //   DocumentReference userDoc =
  //       Firestore.instance.collection('users').document('$uid');
  //   displayName = userDoc.get().then((data) {
  //     return data.data['displayName'].toString();
  //   });

  //   print(displayName);

  //   Firestore.instance
  //       .collection('users')
  //       .document(uid)
  //       .snapshots()
  //       .listen((data) {
  //     displayName = data['displayName'];
  //     photoUrl = data['photoUrl'];
  //   });

  //   Firestore.instance
  //       .collection('chats')
  //       .document(chatId)
  //       .collection('messages')
  //       .orderBy('timestamp', descending: false)
  //       .limit(1)
  //       .getDocuments()
  //       .then((data) => latestMessage = data.documents[0].data['text']);

  //   return Chat(
  //       chatId: chatId,
  //       message: latestMessage,
  //       otherUser: displayName,
  //       otherUserAvatar: photoUrl);
  // }
}
