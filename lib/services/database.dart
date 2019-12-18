import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //collection reference
  final CollectionReference addCollection = Firestore.instance.collection('Annons');
  int docId = 0;

  Future createAdd(String title, String author, String language, int isbn, double price, String condition, String description, String userid) async {
    return await addCollection.add({
      'title': title,
      'author': author,
      'language': language,
      'isbn': isbn,
      'price': price,
      'condition': condition,
      'description': description,
      'userid': userid,
    });
  }

/*Stream<Add> get add {
    return addCollection.s
  }*/
}