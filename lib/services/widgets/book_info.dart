import 'package:flutter/material.dart';

class BookInfo extends StatelessWidget {
  final String first;
  final String second;

  BookInfo({this.first, this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(first, style: TextStyle(color: Colors.grey[600], letterSpacing: 1),),
        Expanded(
          child: Text(second, textAlign: TextAlign.right,))
      ],
    );
  }
}