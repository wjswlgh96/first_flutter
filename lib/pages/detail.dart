import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data = {
    "오우": "야",
  };

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.data['title'].toString()),
      ),
    );
  }
}