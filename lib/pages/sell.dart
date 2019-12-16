import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:student_market_app/services/book_info.dart';

class Sell extends StatefulWidget {
  @override
  _SellState createState() => _SellState();
}

class _SellState extends State<Sell> {
  File _image;

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
                onTap: () {},
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
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Numbers on the back of the book...",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
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
//                  SizedBox(
//                    width: 10,
//                  ),
//                  IconButton(
//                    icon: Icon(FontAwesomeIcons.infoCircle),
//                    onPressed: () {},
//                    color: Colors.grey[600],
//                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 200,
                height: 50,
                child: FlatButton(
                  color: Colors.orange[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Scan"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(FontAwesomeIcons.barcode),
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
                  color: Colors.orange[300],
                ),
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    BookInfo(first: "Title:", second: "C från början"),
                    Divider(
                      height: 20,
                    ),
                    BookInfo(first: "Author:", second: "Jan Jansson"),
                    Divider(
                      height: 20,
                    ),
                    BookInfo(first: "Language:", second: "swe"),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 75,
                      child: FlatButton.icon(
                        color: Colors.red[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.undo),
                        label: Text("Reset"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      height: 75,
                      child: FlatButton(
                        color: Colors.green[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Publish"),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(FontAwesomeIcons.paperPlane),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
