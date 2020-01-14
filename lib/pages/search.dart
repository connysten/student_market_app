import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_market_app/services/add.dart';
import 'package:student_market_app/services/annons_bloc.dart';
import 'package:student_market_app/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:student_market_app/pages/extended_pages/detail_add.dart';
import '../global.dart' as global;

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static final TextEditingController _filter = TextEditingController();
  ScrollController _scroll = ScrollController();
  FocusNode _textFocus = FocusNode();
  AnnonsBloc _annonsBloc;

  @override
  void initState() {
    _filter.addListener(onChange);
    super.initState();
    _annonsBloc = AnnonsBloc();
    _annonsBloc.fetchFirstList("");
    _scroll.addListener(_scrollListener);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          global.darkModeActive == true ? Colors.grey : Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            global.darkModeActive == true ? Colors.black : Colors.orange,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: TextFormField(
                    onChanged:(value) => _annonsBloc.fetchFirstList(value),
                    controller: _filter,
                    focusNode: _textFocus,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: global.currentLanguage == global.Language.eng
                          ? "Search"
                          : "Sök",
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
      body: Container(
        child: SafeArea(
          child: _buildListView(),
        ),
      ),
    );
  }

  void onChange() {
    String text = _filter.text;
    bool hasFocus = _textFocus.hasFocus;

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildListView() {
    return Container(
      child: StreamBuilder(
        stream: _annonsBloc.annonsStream,// DatabaseService().filterAdds(_SearchPageState._filter.text),
        //DatabaseService().query(_SearchPageState._filter.text),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                strokeWidth: 5,
              ),
            );
            /*return Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  strokeWidth: 5,
                ))),
              ],
            );*/
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.toList().length,
            controller: _scroll,
            itemBuilder: (context, index) {
              return Card(
                color: global.darkModeActive == true
                    ? Colors.black54
                    : Colors.white,
                //margin: EdgeInsets.fromLTRB(20.0, 3.0, 20.0, 0.0),
                child: GestureDetector(
                  child: ListTile(
                    leading: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 64,
                        minHeight: 44,
                        maxWidth: 84,
                        maxHeight: 64,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: snapshot.data[index]['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        snapshot.data[index]['title'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: global.darkModeActive == true
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    subtitle: Text(
                      'ISBN: ${snapshot.data[index]['isbn']}',
                      style: TextStyle(
                          color: global.darkModeActive == true
                              ? Colors.grey
                              : Colors.black),
                    ),
                    trailing: Text(
                      '${snapshot.data[index]['price'].toString()} kr',
                      style: TextStyle(
                        color: global.darkModeActive == true
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    onTap: () {
                      /*Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailAddScreen(snapshot.data[index], index);
                  }));*/
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailAdd(snapshot.data[index], index)));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _scrollListener() {
    if (_scroll.offset >= _scroll.position.maxScrollExtent &&
        !_scroll.position.outOfRange) {
      _annonsBloc.fetchNextAnnons();
    }
  }
}

/*class SearchResult extends StatefulWidget {
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

  Widget _buildListView() {
    return Container(
      child: FutureBuilder(
        future: DatabaseService().filterAdds(_SearchPageState._filter.text),
        //DatabaseService().query(_SearchPageState._filter.text),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading...");
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: snapshot.data.toList().length,
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
                      child: Hero(
                        tag: 'Add$index',
                        child: CachedNetworkImage(
                            imageUrl: snapshot.data[index]['imageUrl'],
                            fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(snapshot.data[index]['title']),
                    subtitle: Text('ISBN: ${snapshot.data[index]['isbn']}'),
                    trailing:
                        Text('${snapshot.data[index]['price'].toString()} kr'),
                    onTap: () {
                      /*Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return DetailAddScreen(snapshot.data[index], index);
                    }));*/
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailAdd(snapshot.data[index], index)));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
*/
