import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  //collection reference
  final CollectionReference addCollection = Firestore.instance.collection('Annons');

  Future createAdd(String title, String author, String language, int isbn, double price, String condition, String description, String userid, File image) async {
    var tempUrl = await addImage(image, title);
    var imageUrl = tempUrl.toString();
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
    return await(await uploadTask.onComplete).ref.getDownloadURL();
  }

/*Stream<Add> get add {
    return addCollection.s
  }*/
}