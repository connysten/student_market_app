import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/services/book_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  File _image;
  String isbnText;
  Future<Post> post;
  final txt = TextEditingController();

  @override
  void initState() {
    super.initState();

    txt.addListener(() {
      if (txt.text.length == 13) {
        setState(() {
          post = fetchPost(txt.text);
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: getImage,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 200,
                  child: _image == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.fileImage,
                              color: Colors.grey[600],
                              size: 30,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Add photo",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18),
                            ),
                          ],
                        )
                      : Image.file(_image),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: txt,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Numbers on the back of the book...",
                        hintStyle: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                        labelText: "ISBN",
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey[400],
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        suffixIcon: Icon(
                          FontAwesomeIcons.hashtag,
                          color: Colors.orange,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  color: Colors.orange[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: scan,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Scan ISBN",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        FontAwesomeIcons.barcode,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: FutureBuilder<Post>(
                  future: post,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: <Widget>[
                          BookInfo(
                              first: "Title:",
                              second: snapshot.data.books[0].title),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(
                              first: "Author:",
                              second: snapshot.data.books[0].creator),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(
                              first: "Language:",
                              second: snapshot.data.books[0].language),
                        ],
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          BookInfo(first: "Title:", second: ""),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(first: "Author:", second: ""),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(first: "Language:", second: ""),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[400],
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange[200]),
                  ),
                  suffixIcon: Icon(
                    FontAwesomeIcons.dollarSign,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 5,
                minLines: 5,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey[400],
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.orange[200]),
                  ),
                  suffixIcon: Icon(
                    FontAwesomeIcons.scroll,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.red[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Reset",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(FontAwesomeIcons.undoAlt)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.green[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Publish",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(FontAwesomeIcons.paperPlane)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        isbnText = barcode;
        txt.text = isbnText;
      });
    } catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          isbnText = 'Camera permission not granted';
          txt.text = isbnText;
        });
      } else {
        setState(() {
          isbnText = 'Unknown error $e';
          txt.text = isbnText;
        });
      }
    }
  }

  void getImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Select the image source"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file != null) {
        setState(() => _image = file);
      }
    }
  }

  Future<Post> fetchPost(String query) async {
    final response = await http
        .get('http://api.libris.kb.se/xsearch?query=$query&format=json');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return Post.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}

class Post {
  final int records;
  final List<Book> books;

  Post({this.records, this.books});

  factory Post.fromJson(Map<String, dynamic> json) {
    var list = json['xsearch']['list'] as List;

    return Post(
        records: json['xsearch']['records'],
        books: list.map((i) => Book.fromJson(i)).toList());
  }
}

class Book {
  final String creator;
  final String title;
  final String language;

  Book({this.creator, this.title, this.language});

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> author = json['creator'].split(',');
    String bookTitle =
        json['title'].toString().replaceAll('[Elektronisk resurs]', '');

    return Book(
        creator: author[0] + ',' + author[1],
        title: bookTitle,
        language: json['language']);
  }
}
