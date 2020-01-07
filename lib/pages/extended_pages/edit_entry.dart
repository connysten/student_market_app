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
  final db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Edit Information"),
            backgroundColor: Colors.deepOrangeAccent),
        body: ListView(
          children: <Widget>[
            Column(
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
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: widget.snap['title'],
                    labelText: 'Change title',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: widget.snap['description'],
                    labelText: 'Change Description',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: widget.snap['price'].toString(),
                    labelText: 'Change Price',
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await db
                                .collection('Annons')
                                .document(widget.snap.documentID)
                                .delete();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              color: Color(0xFF404A5C),
                            ),
                            child: Center(
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
