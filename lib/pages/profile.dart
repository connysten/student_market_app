import 'package:flutter/material.dart';
import 'package:student_market_app/services/user_details.dart';

import './extended_pages/user_messages.dart';

class Profile extends StatefulWidget {
  final UserDetails userDetails;
  @override
  _ProfileState createState() => _ProfileState();

  Profile({this.userDetails});
}

class _ProfileState extends State<Profile> {

  Widget _buildProfileImage(){
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i.pinimg.com/originals/97/00/00/970000a282c18eb41e47fd76adda2983.png"),
            fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 5.0,
          )
        ),
      ),
    );
  }

  Widget _buildUserName(){
    TextStyle _nameTextStyle = TextStyle(
      //fontFamily:
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      "Marcus M",
      style: _nameTextStyle,
    );
  }

  Widget _buildCoverImage(Size screenSize){
    return Container(
      height: screenSize.height / 2.8,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/6/66/M%C3%A4lardalens_h%C3%B6gskolas_huvudentr%C3%A9_V%C3%A4ster%C3%A5s.jpg")
        )
      ),
    );
  }

  Widget _buildProgramName(BuildContext context){
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

  Widget _buildStatContainer(){
    return Container(
      height: 60.0,
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

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UserMessages())),
              child: Container(
                height: 40.0,
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
                height: 40.0,
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

  Widget _buildListView(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildListItem("https://media1.tenor.com/images/6aeffef5449984ddec0e5f833f0cece8/tenor.gif?itemid=13154417", "Some Book", "D23FA-32AD-323FF"),
          _buildListItem("https://media1.tenor.com/images/6aeffef5449984ddec0e5f833f0cece8/tenor.gif?itemid=13154417", "Some Book", "D23FA-32AD-323FF"),
          _buildListItem("https://media1.tenor.com/images/6aeffef5449984ddec0e5f833f0cece8/tenor.gif?itemid=13154417", "Some Book", "D23FA-32AD-323FF"),
          _buildListItem("https://media1.tenor.com/images/6aeffef5449984ddec0e5f833f0cece8/tenor.gif?itemid=13154417", "Some Book", "D23FA-32AD-323FF"),
        ],
      ),
    );
  }

  Widget _buildListItem(String srcFile, String heading, String isbn){
    return Container(
      width: 160.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(srcFile),
            ListTile(
              title: Text(heading),
              subtitle: Text(isbn),
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
                  _buildProfileImage(),
                  _buildUserName(),
                  _buildProgramName(context),
                  _buildStatContainer(),
                  _buildListView(),
                  _buildButtons(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
