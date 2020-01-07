import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_market_app/services/add.dart';
import 'package:student_market_app/services/database.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    _filter.addListener(onChange);
    super.initState();
  }
  String _searchText = "";
  static final TextEditingController _filter = new TextEditingController();
  FocusNode _textFocus = new FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: TextFormField(
                    controller: _filter,
                    focusNode: _textFocus,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      icon: Icon(Icons.search, color: Colors.white),
                      hintStyle: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mic, color: Colors.white),
                      ),
                      VerticalDivider(color: Colors.white),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SearchResult(),
    );
  }

  void onChange() {
    String text = _filter.text;
    bool hasFocus = _textFocus.hasFocus;

    if(mounted){
      setState(() {

      });
    }

  }
}

class SearchResult extends StatefulWidget {
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildListView(),
          ],
        ),
      ),
    );
  }
}

Stream<QuerySnapshot> _getQuery() {
  String filter = _SearchPageState._filter.text;
  if (filter == '') {
    return Firestore.instance.collection('Annons').snapshots();
  } else {
    return Firestore.instance
        .collection('Annons')
        .orderBy('title')
        .startAt([filter]).snapshots();
  }
}

Widget _buildListView() {
  return Container(
    child: FutureBuilder(
      future: DatabaseService().query(_SearchPageState._filter.text),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading...");
        }
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: snapshot.data.documents.toList().length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 0.0),
                child: ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 64,
                      minHeight: 44,
                      maxWidth: 84,
                      maxHeight: 64,
                    ),
                    child: Image.network(
                        snapshot.data.documents[index]['imageUrl'],
                        fit: BoxFit.cover),
                  ),
                  title: Text(snapshot.data.documents[index]['title']),
                  subtitle:
                      Text('ISBN: ${snapshot.data.documents[index]['isbn']}'),
                  trailing: Text(
                      '${snapshot.data.documents[index]['price'].toString()} kr'),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}
