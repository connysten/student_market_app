import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_market_app/pages/profile.dart';
import 'package:student_market_app/global.dart' as global;

class EditEntry extends StatefulWidget {
  final int index;
  final DocumentSnapshot snap;

  EditEntry(this.index, this.snap);

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  final db = Firestore.instance;
  final key = GlobalKey<ScaffoldState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: global.darkModeActive == true ? Colors.grey : null,
      key: key,
        appBar: AppBar(
            title: Text("Edit Information"),
            backgroundColor: global.darkModeActive == true ? Colors.black54 : Colors.orange),
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
                  controller: _titleController,
                  onSubmitted: (text) async {
                    await db
                        .collection('Annons')
                        .document(widget.snap.documentID)
                        .updateData({'title': _titleController.text});
                    setState(() {});
                    key.currentState.showSnackBar(SnackBar(
                      content: Text("Title has been changed to " + _titleController.text + "!"),
                    ));
                  },
                  decoration: InputDecoration(
                    hintText: widget.snap['title'],
                    labelText: 'Change title',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _descController,
                  onSubmitted: (text) async {
                    await db
                        .collection('Annons')
                        .document(widget.snap.documentID)
                        .updateData({'description': _descController.text});
                    setState(() {});
                    key.currentState.showSnackBar(SnackBar(
                      content: Text("Description has been changed to " + _descController.text + "!"),
                    ));
                  },
                  decoration: InputDecoration(
                    hintText: widget.snap['description'],
                    labelText: 'Change Description',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _priceController,
                  onSubmitted: (text) async {
                    await db
                        .collection('Annons')
                        .document(widget.snap.documentID)
                        .updateData({'price': _priceController.text});
                    setState(() {});
                    key.currentState.showSnackBar(SnackBar(
                      content: Text("Price has been changed to " + _priceController.text + "!"),
                    ));
                  },
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
                        child: RaisedButton(
                          color: Color(0xFF404A5C),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          onPressed: () async {
                            await db
                                .collection('Annons')
                                .document(widget.snap.documentID)
                                .delete();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
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
