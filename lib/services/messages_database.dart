import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:student_market_app/global.dart';
import 'package:student_market_app/services/chat_with_other_user.dart';
import 'package:uuid/uuid.dart';
import 'package:student_market_app/services/add.dart';

class MessagesDatabaseService {
  Stream<List<ChatWithOtherUser>> getStream() {
    return Firestore.instance
        .collection('chats')
        .where('user', isEqualTo: user.uid)
        .snapshots()
        .asyncMap((QuerySnapshot chatSnap) => chatsToPairs(chatSnap));
  }

  Future<List<ChatWithOtherUser>> chatsToPairs(QuerySnapshot chatSnap) {
    return Future.wait(chatSnap.documents.map((DocumentSnapshot chatDoc) async {
      return await chatToPair(chatDoc);
    }).toList());
  }

  Future<ChatWithOtherUser> chatToPair(DocumentSnapshot chatDoc) {
    return Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: chatDoc.data['otherUser'])
        .getDocuments()
        .then((userSnap) async {
      User otherUser;
      if (userSnap.documents == null) {
        return ChatWithOtherUser();
      }
      for (var doc in userSnap.documents) {
        otherUser = User(
            displayName: doc.data['displayName'],
            email: doc.data['email'],
            photoUrl: doc.data['photoUrl'],
            uid: doc.data['uid']);
      }

      return ChatWithOtherUser(
          chatId: chatDoc.documentID,
          otherUser: otherUser,
          otherChatId: await getOtherChatId(otherUser.uid),
          lastMessage: await getLastMessage(chatDoc.documentID));
    });
  }

  Future<String> getOtherChatId(String otherUserUid) async {
    return Firestore.instance
        .collection('chats')
        .where('user', isEqualTo: otherUserUid)
        .where('otherUser', isEqualTo: user.uid)
        .getDocuments()
        .then((data) =>
            data.documents.length > 0 ? data.documents[0].documentID : null);
  }

  Future<String> getLastMessage(String chatId) async {
    return Firestore.instance
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .getDocuments()
        .then((data) =>
            data.documents.length > 0 ? data.documents[0].data['text'] : null);
  }

  Future<User> getUser(String uid) async {
    return await Firestore.instance
        .collection('users')
        .document(uid)
        .get()
        .then((doc) {
      return User(
          uid: uid,
          displayName: doc.data['displayName'],
          email: doc.data['email'],
          photoUrl: doc.data['photoUrl']);
    });
  }
}
