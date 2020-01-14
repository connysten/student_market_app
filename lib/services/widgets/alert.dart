import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:student_market_app/global.dart' as global;

import '../../global.dart';

class Alert {
  Future<void> removeChat(BuildContext context, String chatId) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              global.currentLanguage == Language.eng
                  ? 'Delete Chat?'
                  : 'Ta Bort Chatt?',
            ),
            content: Text(
              global.currentLanguage == Language.eng
                  ? 'Are you sure you want to delete this chat?'
                  : 'Är du säker på att du vill ta bort denna konversation?',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  global.currentLanguage == Language.eng ? 'Yes' : 'Ja',
                ),
                onPressed: () async {
                  await removeChatDb(chatId);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  child: Text(global.currentLanguage == Language.eng ? 'No' : 'Nej',), onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  Future<void> removeChatDb(String chatId) async {
    var docRef = Firestore.instance.collection('chats').document(chatId);
    Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(docRef);
    });
  }
}
