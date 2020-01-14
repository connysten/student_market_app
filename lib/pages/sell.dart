import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/services/database.dart';
import 'package:student_market_app/services/widgets/book_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../global.dart' as global;

class Sell extends StatefulWidget {
  Sell({Key key}) : super(key: key);

  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  File _image;
  Future<Book> book;
  Book tempBook;
  double condition = 0;
  final conditions = ['Poor', 'Used', 'Barely used', 'As new'];
  final isbnController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isbnController.addListener(() {
      if (isbnController.text.length == 13) {
        setState(() {
          book = fetchBook(isbnController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: global.darkModeActive == true ? Colors.grey : Colors.white,
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
                              global.currentLanguage == global.Language.eng
                                  ? "Add photo"
                                  : "Lägg till foto",
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
                      onChanged: (text) {
                        setState(() {});
                      },
                      controller: isbnController,
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
                        global.currentLanguage == global.Language.eng
                            ? "Scan ISBN"
                            : "Skanna ISBN",
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
                child: isbnController.text.length == 13
                    ? FutureBuilder<Book>(
                        future: book,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: <Widget>[
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Title:"
                                        : "Titel",
                                    second: snapshot.data.title),
                                Divider(
                                  height: 20,
                                ),
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Author:"
                                        : "Författare",
                                    second: snapshot.data.creator),
                                Divider(
                                  height: 20,
                                ),
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Language:"
                                        : "Språk",
                                    second: snapshot.data.language),
                              ],
                            );
                          } else {
                            return Column(
                              children: <Widget>[
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Title:"
                                        : "Titel",
                                    second: ""),
                                Divider(
                                  height: 20,
                                ),
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Author:"
                                        : "Författe",
                                    second: ""),
                                Divider(
                                  height: 20,
                                ),
                                BookInfo(
                                    first: global.currentLanguage ==
                                            global.Language.eng
                                        ? "Language:"
                                        : "Språk",
                                    second: ""),
                              ],
                            );
                          }
                        },
                      )
                    : Column(
                        children: <Widget>[
                          BookInfo(
                              first:
                                  global.currentLanguage == global.Language.eng
                                      ? "Title:"
                                      : "Titel",
                              second: ""),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(
                              first:
                                  global.currentLanguage == global.Language.eng
                                      ? "Author:"
                                      : "Författare",
                              second: ""),
                          Divider(
                            height: 20,
                          ),
                          BookInfo(
                              first:
                                  global.currentLanguage == global.Language.eng
                                      ? "Language:"
                                      : "Språk",
                              second: ""),
                        ],
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: priceController,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: global.currentLanguage == global.Language.eng
                      ? "Price"
                      : "Pris",
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
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Text(global.currentLanguage == global.Language.eng
                        ? 'Condition: '
                        : "Skick"),
                    Expanded(
                      child: Slider(
                        activeColor: Colors.orange,
                        value: condition,
                        onChanged: (newCondition) {
                          setState(() {
                            condition = newCondition;
                          });
                        },
                        divisions: 3,
                        min: 0,
                        max: 3,
                        label: conditions[condition.toInt()],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                minLines: 5,
                maxLength: 255,
                decoration: InputDecoration(
                  labelText: global.currentLanguage == global.Language.eng
                      ? "Description"
                      : "Beskrivning",
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
              Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: reset,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            global.currentLanguage == global.Language.eng
                                ? "Clear"
                                : "Återställ",
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      color: Colors.green[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        DatabaseService().createAdd(
                          tempBook.title,
                          tempBook.creator,
                          tempBook.language,
                          int.parse(isbnController.text),
                          double.parse(priceController.text),
                          conditions[condition.toInt()],
                          descriptionController.text,
                          global.user.uid,
                          _image,
                        );
                        reset();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            global.currentLanguage == global.Language.eng
                                ? "Publish"
                                : "Publicera",
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
                ],
              ),
              /*Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.green[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          DatabaseService().createAdd(
                            tempBook.title,
                            tempBook.creator,
                            tempBook.language,
                            int.parse(isbnController.text),
                            double.parse(priceController.text),
                            conditions[condition.toInt()],
                            descriptionController.text,
                            global.user.uid,
                            _image,
                          );
                          reset();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              global.currentLanguage == global.Language.eng
                                  ? "Publish"
                                  : "Publicera",
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        color: Colors.red[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: reset,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              global.currentLanguage == global.Language.eng
                                  ? "Reset"
                                  : "Börja om",
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
                ],
              ),*/
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      isbnController.text = '';
      priceController.text = '';
      descriptionController.text = '';
      _image = null;
    });
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        isbnController.text = barcode;
      });
    } catch (e) {}
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

  Future<Book> fetchBook(String query) async {
    final response = await http
        .get('http://api.libris.kb.se/xsearch?query=$query&format=json');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      setState(() {
        tempBook = Book.fromJson(json.decode(response.body));
      });
      return tempBook;
    } else {
      return null;
    }
  }
}

class Book {
  final String creator;
  final String title;
  final String language;

  Book({this.creator, this.title, this.language});

  factory Book.fromJson(Map<String, dynamic> json) {
    var book = json['xsearch']['list'][0];
    List<String> author = book['creator'].split(',');
    String bookTitle =
        book['title'].toString().replaceAll('[Elektronisk resurs]', '');

    if (author.length == 1) {
      return Book(
          creator: author[0], title: bookTitle, language: book['language']);
    } else {
      return Book(
          creator: author[0] + ',' + author[1],
          title: bookTitle,
          language: book['language']);
    }
  }
}
