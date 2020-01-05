import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_market_app/pages/profile.dart';

class EditEntry extends StatefulWidget {
  final int index;
  final DocumentSnapshot snap;

  EditEntry(this.index, this.snap);

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Edit Information"),
            backgroundColor: Colors.deepOrangeAccent),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: GestureDetector(
                child: Hero(
                  tag: 'editTag' + widget.index.toString(),
                  child: Image.network(
                    widget.snap['imageUrl'],
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: widget.snap['title'],
                labelText: 'Change title',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: widget.snap['description'],
                labelText: 'Change Description',
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.snap['price'].toString(),
                labelText: 'Change Price',
              ),
            )
          ],
        ));
  }
}
