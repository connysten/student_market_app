import 'package:flutter/material.dart';

//import 'package:student_market_app/services/user_details.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'extended_pages/edit_entry.dart';
import 'package:student_market_app/global.dart';

class Profile extends StatefulWidget {
  //final UserDetails userDetails;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget _buildProfileImage(Size screenSize) {
    return Center(
      child: Container(
        width: screenSize.height / 5.5,
        height: screenSize.height / 5.5,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(user.photoUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 5.0,
            )),
      ),
    );
  }

  Widget _buildUserName() {
    TextStyle _nameTextStyle = TextStyle(
      //fontFamily:
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      user.displayName,
      style: _nameTextStyle,
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.8,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/6/66/M%C3%A4lardalens_h%C3%B6gskolas_huvudentr%C3%A9_V%C3%A4ster%C3%A5s.jpg"),
              fit: BoxFit.cover)),
    );
  }

  Widget _buildProgramName(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        "Datavetenskap",
        style: TextStyle(
          //fontFamily:
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatContainer(Size screenSize) {
    return Container(
      height: screenSize.height / 12,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4F7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Views", "77"),
          _buildStatItem("Active Ads", "4"),
          _buildStatItem("Member since", "2018/11/22"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      //fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }

  Widget _buildButtons(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("Messages"),
              child: Container(
                height: screenSize.height / 20,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Log out"),
              child: Container(
                height: screenSize.height / 20,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Log out",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(Size screenSize) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: screenSize.height / 4.5,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('Annons')
              .where('userid', isEqualTo: user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            }
            else if(snapshot.data.documents.toList().length == 0){
              return Text("No adds");
            }
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.documents.toList().length,
                itemBuilder: (context, index) {
                  return _buildListItem(
                      context, snapshot.data.documents[index], index);
                });
          },
        ));
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot document, int index) {
    return Container(
      width: 160.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            GestureDetector(
              child: Hero(
                tag: 'editTag' + index.toString(),
                child: Image.network(
                  document['imageUrl'],
                  height: 100,
                  width: 150,
                  fit: BoxFit.fill,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditEntry(index, document)));
              },
            ),
            ListTile(
              title: Text(document["title"]),
              subtitle: Text("Price: " + (document["price"]).toString()),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 5.3),
                  _buildProfileImage(screenSize),
                  _buildUserName(),
                  _buildProgramName(context),
                  _buildStatContainer(screenSize),
                  _buildListView(screenSize),
                  _buildButtons(screenSize),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
