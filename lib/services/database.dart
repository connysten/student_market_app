import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:student_market_app/services/add.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  //collection reference
  final CollectionReference addCollection =
      Firestore.instance.collection('Annons');

  Future createAdd(
      String title,
      String author,
      String language,
      int isbn,
      double price,
      String condition,
      String description,
      String userid,
      File image) async {
    var tempUrl = await addImage(image, title);
    var imageUrl = tempUrl.toString();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm d MMM').format(now);
    return await addCollection.add({
      'title': title,
      'author': author,
      'language': language,
      'isbn': isbn,
      'price': price,
      'condition': condition,
      'description': description,
      'userid': userid,
      'imageUrl': imageUrl,
      'timestamp': formattedDate,
    });
  }

  Future<String> addImage(File image, String title) async {
    var uploadedFileUrl;
    var uuid = Uuid().v1();
    StorageReference ref = FirebaseStorage.instance.ref().child('books/$uuid');
    /*StorageUploadTask uploadTask = ref.putFile(image);
    ref.getDownloadURL().then((fileURL) {
      uploadedFileUrl = fileURL;
    });
    return uploadedFileUrl;*/
    StorageUploadTask uploadTask = ref.putFile(image);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  List<Add> _addListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Add(
        title: doc.data['name'] ?? '',
        author: doc.data['author'] ?? '',
        language: doc.data['language'] ?? '',
        isbn: doc.data['isbn'] ?? 0,
        price: doc.data['price'] ?? 0,
        condition: doc.data['condition'] ?? '',
        description: doc.data['description'] ?? '',
        userid: doc.data['userid'] ?? 0,
        imageUrl: doc.data['imageUrl'],
      );
    }).toList();
  }

  Stream<List<Add>> get adds {
    return addCollection.snapshots().map(_addListFromSnapshot);
  }

  Future<QuerySnapshot> query(String filter) async {
    QuerySnapshot temp =
        await addCollection.orderBy('title').startAt([filter])
            .endAt([filter + "\uf8ff"])
            .getDocuments();
    return temp;
  }

  Future<List<DocumentSnapshot>> filterAdds(String filter) async {
    QuerySnapshot allAdds = await addCollection.orderBy('price').getDocuments();
    List<DocumentSnapshot> allAddsDocs = allAdds.documents;
    List<DocumentSnapshot> filteredAdds = new List<DocumentSnapshot>();
    for(var item in allAddsDocs){
      if(item['title'].toLowerCase().contains(filter) || item['isbn'].toString().contains(filter)){
        filteredAdds.add(item);
      }
    }
    return filteredAdds;
  }
/*Stream<Add> get add {
    return addCollection.s
  }*/
}
