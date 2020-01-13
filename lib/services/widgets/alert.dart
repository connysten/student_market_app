import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Alert {
  Future<void> removeChat(BuildContext context, String chatId) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Chat?'),
            content: Text('Are you sure you want to delete this chat?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  await removeChatDb(chatId);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                  child: Text('No'), onPressed: () => Navigator.pop(context))
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
